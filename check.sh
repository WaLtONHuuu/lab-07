# assume all tests will pass, if any test fails, set this to 0
all_pass=1

for num in 1 2 3 4
do
    input_dir="Testcase$num"
    output_dir="Testcase${num}Diff"

    testcase_pass=1
    has_difference=0

    for file1 in "$input_dir"/*.1.txt
    do
        file2="${file1%.1.txt}.2.txt"

        filename="${file1##*/}"
        name="${filename%.1.txt}"
        output_file="$output_dir/${name}Diff.txt"

        # compare the two files and check if they are the same
        if cmp -s "$file1" "$file2"
        then
            # there should be no output file if the two files are the same
            if [ -e "$output_file" ]
            then
                # if the output file exists, the test case fails, testcase_pass is set to 0
                testcase_pass=0
            fi
        else
            # there is a difference between the two files, so we expect an output file to exist
            has_difference=1
            
            # check if the output file exists
            if [ ! -f "$output_file" ]
            then
                testcase_pass=0

            # check if the out put file matches the expected diff, ignoring the first two lines
            elif ! cmp -s \
                <(diff -u "$file1" "$file2" | tail -n +3) \
                <(tail -n +3 "$output_file")
            then
                testcase_pass=0
            fi
        fi
    done

    # finally check if the output directory exists
    if [ "$has_difference" -eq 1 ]
    then
        if [ ! -d "$output_dir" ]
        then
            testcase_pass=0
        fi
    else
        if [ -e "$output_dir" ]
        then
            testcase_pass=0
        fi
    fi

    # print out the result of the test case
    if [ "$testcase_pass" -eq 1 ]
    then
        echo "Testcase$num: PASS"
    else
        echo "Testcase$num: FAIL"
        all_pass=0
    fi
done

# decide whether to end the bash script or not
if [ "$all_pass" -eq 1 ]
then
    exit 0
else
    exit 1
fi