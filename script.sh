for num in 1 2 3 4
do
    input_dir="Testcase$num"
    output_dir="Testcase${num}Diff"

    # avoid duplicate output files from previous runs
    rm -rf "$output_dir"

    for file1 in "$input_dir"/*.1.txt
    do
        # get the corresponding .2.txt file
        file2="${file1%.1.txt}.2.txt"

        # get the filename without the directory
        filename="${file1##*/}"
        name="${filename%.1.txt}"

        # compare the two files and generate the diff if they are different
        if ! cmp -s "$file1" "$file2"
        then
            # create the output directory of differences
            mkdir -p "$output_dir"

            # generate the diff and save it to the output directory
            diff -u "$file1" "$file2" \
                > "$output_dir/${name}Diff.txt"
        fi
    done
done