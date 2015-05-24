#!/bin/bash
###############################################################################
# Converting eBooks with Calibre ebook-convert                                #
#                                                                             #
# Authors: Axel Hoffmann, Matthias Becker                                     #
#                                                                             #
# Converts eBooks with spaces and in subfolders. The formats array contains   #
# all wished eBook formats in the order of their priority. An eBook can be    #
# located in the same folder like the script or in a subfolder. If an eBook   #
# with the same name but one or more formats are located in the same folder,  #
# the missing formats will be generated from the existing ones. Which source  #
# format is preferred, is given by order of the formats array. Generated      #
# files won't be used for conversation.                                       #
###############################################################################
IFS=$'\n'

ebookconvert=`which ebook-convert`
dat=`date +%Y-%m-%d_%H-%M-%S`
logfile=calibre-convert_$dat.log

# Clean up logfiles
logfiles=($(eval "ls *.log" | sort))
if [ ${#logfiles[@]} -gt 10 ]
    then for (( i=0; i<${#logfiles[@]}-1; i++ ))
    do
        rm ${logfiles[$i]}
    done
fi

# eBook source and target formats in the order of their priority
formats=('epub' 'mobi' 'pdf')

# Function which checks if an item is contained in an array
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

# Preparation of the search parameters
find_formats=`echo ${formats[@]} | \
    sed 's/\>/"/g;s/\</-iname\ "\*\./g;s/-iname/-or\ -iname/2g'`

# Find all existing paths and filenames of eBooks
filenames=($(eval "find . -type f $find_formats" | sort))

# Extract the paths and names of eBooks without extensions
books=()
for file in "${filenames[@]}"
do
    if ! exists_in_array ${file%.*} ${books[@]}
        then books+=(${file%.*})
    fi
done

# For every eBook, check which target format not exist and then use the first
# existing source format to convert it.
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
                        then 
                            echo -e $ebookconvert $book.$sformat $book.$tformat >> $logfile
                            $ebookconvert $book.$sformat $book.$tformat >> $logfile
                            break
                    fi
                done
        fi
    done
done

