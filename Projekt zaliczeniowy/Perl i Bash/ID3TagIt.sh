#!/bin/bash
#Jakub Jas, grupa 2
#    ___ ____ __________           ___ _
#   |_ _|  _ \___ /_   _|_ _  __ _|_ _| |_
#    | || | | ||_ \ | |/ _` |/ _` || || __|
#    | || |_| |__) || | (_| | (_| || || |_
#   |___|____/____/ |_|\__,_|\__, |___|\__|
#                            |___/

box()
{
    str="$@"
    len=$((${#str}+4))

    for i in $(seq $len)
    do
    	echo -n '*'
    done

    echo
    echo "* "$str" *"

    for i in $(seq $len)
    do
    	echo -n '*'
    done

    echo
}

usage()
{
  echo "
      ___ ____ __________           ___ _
     |_ _|  _ \___ /_   _|_ _  __ _|_ _| |_
      | || | | ||_ \ | |/ _\` |/ _\` || || __|
      | || |_| |__) || | (_| | (_| || || |_
     |___|____/____/ |_|\__,_|\__, |___|\__|
                              |___/         "
	box "Utility for editing and displaying ID3v1 data"
	echo
	echo "Usage: $0 <options> <files>"
	echo
	echo "Options:"
	echo "-h : help"
	echo "-d : display mode"
  echo "-e : edit mode"
  echo "-a : group data by artist (in display mode), edit artist (in edit mode)"
  echo "-b : group data by album (in display mode), edit album (in edit mode)"
  echo "-y : group data by year (in display mode), edit year (in edit mode)"
  echo "-n : edit track number (in edit mode)"
  echo "-t : edit title (in edit mode)"
	echo
}

absolute_path=$PWD

cd "$(dirname "$0")"

export PERL5LIB=$PWD

OPTIND=1

display=0
edit=0
album=0
artist=0
number=0
title=0
year=0

while getopts "h?deabnty" opt; do
    case "$opt" in
    h|\?)
        usage
        exit 0
        ;;
    d)  display=1
        ;;
    e)  edit=1
        ;;
    a)  artist=1
        ;;
    b)  album=1
        ;;
    n)  number=1
        ;;
    t)  title=1
        ;;
    y)  year=1
        ;;
    esac
done

shift $((OPTIND-1))

[ "$1" = "--" ] && shift

if [[ -z "$@" ]];
then
  usage
  exit 1
fi

if [ "$display" -eq 1 ] && [ "$edit" -ne 1 ];
then

  if [ "$album" -eq 1 ] && [ "$artist" -eq 0 ] && [ "$title" -eq 0 ] && [ "$number" -eq 0 ] && [ "$year" -eq 0 ];
  then
    perl DisplayGroupedByAlbum.pl "$absolute_path" "$@"

  elif [ "$album" -eq 0 ] && [ "$artist" -eq 1 ] && [ "$title" -eq 0 ] && [ "$number" -eq 0 ] && [ "$year" -eq 0 ];
  then
    perl DisplayGroupedByArtist.pl "$absolute_path" "$@"

  elif [ "$album" -eq 0 ] && [ "$artist" -eq 0 ] && [ "$title" -eq 0 ] && [ "$number" -eq 0 ] && [ "$year" -eq 1 ];
  then
    perl DisplayGroupedByYear.pl "$absolute_path" "$@"

  elif [ "$album" -eq 0 ] && [ "$artist" -eq 0 ] && [ "$title" -eq 0 ] && [ "$number" -eq 0 ] && [ "$year" -eq 0 ];
  then
    perl DisplayGroupedByAlbum.pl "$absolute_path" "$@"

  else
    usage
    exit 2

  fi

elif [ "$edit" -eq 1 ] && [ "$display" -ne 1 ];
then

  if [ "$artist" -eq 0 ] && [ "$title" -eq 0 ] && [ "$number" -eq 0 ] && [ "$album" -eq 0 ] && [ "$year" -eq 0 ];
  then
    perl EditID3v1.pl 00000 "$absolute_path" "$@"

  else
    if [ $artist -eq 1 ]; then
      a="a";
    fi

    if [ $album -eq 1 ]; then
      b="b";
    fi

    if [ $number -eq 1 ]; then
      n="n";
    fi

    if [ $title -eq 1 ]; then
      t="t";
    fi

    if [ $year -eq 1 ]; then
      y="y";
    fi

    perl EditID3v1.pl $a$b$n$t$y "$absolute_path" "$@"

  fi

else
  usage
  exit 3

fi
