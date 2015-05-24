#!/bin/bash
ebookconvert=/usr/bin/ebook-convert
IFS=$'\n'
formats=('epub' 'mobi' 'pdf')

exists_in_array() {
    local element=$1 && shift
    local array=($@)

    for item in "${array[@]}"
    do
        if [[ $item == $element ]]
            then return 0
        fi
    done
    return 1
}


#find_formats=`echo ${formats[@]} | sed 's/\</\*\./g;s/\>/\n/g;s/\ //g'`
find_formats=`echo ${formats[@]} | sed 's/\>/"/g;s/\</-iname\ "\*\./g;s/-iname/-or\ -iname/2g'`

filenames=($(eval "find . -type f $find_formats" | sort))

books=()
for file in "${filenames[@]}"
do
    if ! exists_in_array ${file%.*} ${books[@]}
        then books+=(${file%.*})
    fi
done

#books=($(echo -e ${filenames[@]} | sed 's/\<\(.*\)\..*\>/\1/g' | sort | uniq))
#books=($(eval "find . -type f $find_formats" | sed 's/\(.*\)\..*/\1/' | sort | uniq))

echo ${filenames[@]}
echo ${books[@]}

#books=($(find . -type f | sed 's/\(.*\)\..*/\1/' | sort | uniq ))
#b=('blubbb' 'blaaa' 'wakken sd')
#
#if exist_in_array "wakken sd" ${b[@]} 
#    then echo "ja"
#else
#    echo "nein"
#fi

for book in ${books[@]}
do
    for tformat in ${formats[@]}
    do
        if ! exists_in_array $book.$tformat ${filenames[@]}
            then 
                sformats=( "${formats[@]/$tformat}" )
                for sformat in ${sformats[@]}
                do
                    if exists_in_array $book.$sformat ${filenames[@]}
                        then $ebookconvert $book.$sformat $book.$tformat
                        break
                    fi
                done
        fi
    done
done

