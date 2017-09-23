#!/bin/sh
#
# An example hook script to verify what is about to be committed.
# Called by "git commit" with no arguments.  The hook should
# exit with non-zero status after issuing an appropriate message if
# it wants to stop the commit.
#
# To enable this hook, rename this file to "pre-commit".
echo "=== check_syntax.sh"

if git rev-parse --verify HEAD >/dev/null 2>&1
then
        against=HEAD
else
        # Initial commit: diff against an empty tree object
        against=4b825dc642cb6eb9a060e54bf8d69288fbee4904
fi

against=4b825dc642cb6eb9a060e54bf8d69288fbee4904

echo "against=$against"

# If you want to allow non-ASCII filenames set this variable to true.
allownonascii=$(git config --bool hooks.allownonascii)

# Redirect output to stderr.
exec 1>&2


# If there are whitespace errors, print the offending file names and fail.
exec git diff-index --check --cached $against --


syntax_errors=0
error_msg=$(mktemp /tmp/error_msg.XXXXXX)

echo "=== against=$against"
git diff-index --diff-filter=AM --name-only --cached $against | egrep '\.(pp|erb)'
echo "=== XXXXXX"

# aboting commit
exit 1

# Get list of new/modified manifest and template files to check (in git index)
for indexfile in `git diff-index --diff-filter=AM --name-only --cached $against | egrep '\.(pp|erb)'`
do
    echo " ======> $indexfile"
    # Don't check empty files
    if [ 'git cat-file -s :0:$indexfile' -gt 0 ]
    then
        case $indexfile in
            *.pp )
                # Check puppet manifest syntax
                git cat-file blob :0:$indexfile | puppet parser validate > $error_msg ;;
            *.erb )
                # Check ERB template syntax
                git cat-file blob :0:$indexfile | erb -x -T - | ruby -c 2> $error_msg > /dev/null ;;
        esac
        if [ "$?" -ne 0 ]
        then
            echo -n "$indexfile: "
            cat $error_msg
            syntax_errors='expr $syntax_errors + 1'
        fi
    fi
done

rm -f $error_msg

if [ "$syntax_errors" -ne 0 ]
then
    echo "Error: $syntax_errors syntax errors found, aborting commit."
    exit 1
fi
