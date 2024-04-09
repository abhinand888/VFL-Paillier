#! /bin/bash
summaryfile=~/summary.txt

# create a copy of summary.txt file
cp $summaryfile $summaryfile-old

# Assume Job Id1 = $1, container name1 = $2, Model = $3, Comment = $4, Job Id2 = $5, container name2 = $6

echo "`date`" | tee -a $summaryfile

###### FOR the first Job


# Execute fate_paillier.sh to get the logs folder from the container and store the files
~/fate_paillier.sh $1 $2 $3

#Separate to LOG files
~/separating.sh $1 $2 $3

cd ~/logs/fate_paillier1

echo "Summary of $1 - $2 - $3 - $4" | tee -a $summaryfile
echo "*********************************************************************" | tee -a $summaryfile
echo -e "\n" | tee -a $summaryfile

ASUM1="0"
GSUM1="0"
HSUM1="0"
AFLAG="0"
ADONE="0"
GFLAG="0"
GDONE="0"
HFLAG="0"
HDONE="0"
GRANDTOTAL1="0"


for i in `find . -name *.LOG -path "*$1*" | sort`
do  
read -r  type time lines < <(~/myscript3.sh $i| cut -d"#" -f2,4,6 | awk -F "#" '{print substr($1, length($1)-6, 3),$3, $2  }')



case $type in
   "ANA")   ANA1=$time
    ;;
   "AND")   AND1=$time
    ;;
   "ANE")   ANE1=$time
    ;;
   "ANM")   ANM1=$time
    ;;
   "AXA")   AXA1=$time
            AA1=`echo "$AXA1 - $ANA1" | bc -l`
            AFLAG=1
            ASUM1=`echo "$ASUM1 + $AA1" | bc -l`
            echo "Time for Arbiter Add = $AA1" | tee -a $summaryfile
            echo "#lines = $lines" | tee -a $summaryfile
    ;;
   "AXD")   AXD1=$time
            AD1=`echo "$AXD1 - $AND1" | bc -l`
            AFLAG=1
            ASUM1=`echo "$ASUM1 + $AD1" | bc -l`
            echo "Time for Arbiter Decrypt = $AD1" | tee -a $summaryfile
            echo "#lines = $lines" | tee -a $summaryfile
    ;;
   "AXE")   AXE1=$time
            AE1=`echo "$AXE1 - $ANE1" | bc -l`
            AFLAG=1
            ASUM1=`echo "$ASUM1 + $AE1" | bc -l`
            echo "Time for Arbiter Encrypt = $AE1" | tee -a $summaryfile
            echo "#lines = $lines" | tee -a $summaryfile
    ;;
   "AXM")   AXM1=$time
            AM1=`echo "$AXM1 - $ANM1" | bc -l`
            AFLAG=1
            ASUM1=`echo "$ASUM1 + $AM1" | bc -l`
            echo "Time for Arbiter Multiply = $AM1" | tee -a $summaryfile
            echo "#lines = $lines" | tee -a $summaryfile
    ;;
   "GNA")   GNA1=$time
    ;;
   "GND")   GND1=$time
    ;;
   "GNE")   GNE1=$time
    ;;
   "GNM")   GNM1=$time
    ;;
   "GXA")   GXA1=$time
            GA1=`echo "$GXA1 - $GNA1" | bc -l`
            if [ $AFLAG == "1" -a $ADONE == "0" ]
            then
            #display Arbiter summary
               echo "TOTAL TIME FOR ARBITER = $ASUM1" | tee -a $summaryfile
               ADONE=1
            fi
            GFLAG=1
            GSUM1=`echo "$GSUM1 + $GA1" | bc -l`
            echo "Time for Guest Add = $GA1" | tee -a $summaryfile
            echo "#lines = $lines" | tee -a $summaryfile
    ;;
   "GXD")   GXD1=$time
            GD1=`echo "$GXD1 - $GND1" | bc -l`
            if [ $AFLAG == "1" -a $ADONE == "0" ]
            then
            #display Arbiter summary
               echo "TOTAL TIME FOR ARBITER = $ASUM1" | tee -a $summaryfile
               ADONE=1
            fi
            GFLAG=1
            GSUM1=`echo "$GSUM1 + $GD1" | bc -l`
            echo "Time for Guest Decrypt = $GD1" | tee -a $summaryfile
            echo "#lines = $lines" | tee -a $summaryfile
    ;;
   "GXE")   GXE1=$time
            GE1=`echo "$GXE1 - $GNE1" | bc -l`
            if [ $AFLAG == "1" -a $ADONE == "0" ]
            then
            #display Arbiter summary
               echo "TOTAL TIME FOR ARBITER = $ASUM1" | tee -a $summaryfile
               ADONE=1
            fi
            GFLAG=1
            GSUM1=`echo "$GSUM1 + $GE1" | bc -l`
            echo "Time for Guest Encrypt = $GE1" | tee -a $summaryfile
            echo "#lines = $lines" | tee -a $summaryfile
    ;;
   "GXM")   GXM1=$time
            GM1=`echo "$GXM1 - $GNM1" | bc -l`
            if [ $AFLAG == "1" -a $ADONE == "0" ]
            then
            #display Arbiter summary
               echo "TOTAL TIME FOR ARBITER = $ASUM1" | tee -a $summaryfile
               ADONE=1
            fi
            GFLAG=1
            GSUM1=`echo "$GSUM1 + $GM1" | bc -l`
            echo "Time for Guest Multiply = $GM1" | tee -a $summaryfile
            echo "#lines = $lines" | tee -a $summaryfile
    ;;
   "HNA")   HNA1=$time
    ;;
   "HND")   HND1=$time
    ;;
   "HNE")   HNE1=$time
    ;;
   "HNM")   HNM1=$time
    ;;
   "HXA")   HXA1=$time
            HA1=`echo "$HXA1 - $HNA1" | bc -l`
            if [ $AFLAG == "1" -a $ADONE == "0" ]
            then
            #display Arbiter summary
               echo "TOTAL TIME FOR ARBITER = $ASUM1" | tee -a $summaryfile
               ADONE=1
            fi
            if [ $GFLAG == "1" -a $GDONE == "0" ]
            then
            #display Guest summary
               echo "TOTAL TIME FOR GUEST = $GSUM1" | tee -a $summaryfile
               GDONE=1
            fi
            HFLAG=1
            HSUM1=`echo "$HSUM1 + $HA1" | bc -l`
            echo "Time for Host Add = $HA1" | tee -a $summaryfile
            echo "#lines = $lines" | tee -a $summaryfile
    ;;
   "HXD")   HXD1=$time
            HD1=`echo "$HXD1 - $HND1" | bc -l`
            if [ $AFLAG == "1" -a $ADONE == "0" ]
            then
            #display Arbiter summary
               echo "TOTAL TIME FOR ARBITER = $ASUM1" | tee -a $summaryfile
               ADONE=1
            fi
            if [ $GFLAG == "1" -a $GDONE == "0" ]
            then
            #display Guest summary
               echo "TOTAL TIME FOR GUEST = $GSUM1" | tee -a $summaryfile
               GDONE=1
            fi
            HFLAG=1
            HSUM1=`echo "$HSUM1 + $HD1" | bc -l`
            echo "Time for Host Decrypt = $HD1" | tee -a $summaryfile
            echo "#lines = $lines" | tee -a $summaryfile
    ;;
   "HXE")   HXE1=$time
            HE1=`echo "$HXE1 - $HNE1" | bc -l`
            if [ $AFLAG == "1" -a $ADONE == "0" ]
            then
            #display Arbiter summary
               echo "TOTAL TIME FOR ARBITER = $ASUM1" | tee -a $summaryfile
               ADONE=1
            fi
            if [ $GFLAG == "1" -a $GDONE == "0" ]
            then
            #display Guest summary
               echo "TOTAL TIME FOR GUEST = $GSUM1" | tee -a $summaryfile
               GDONE=1
            fi
            HFLAG=1
            HSUM1=`echo "$HSUM1 + $HE1" | bc -l`
            echo "Time for Host Encrypt = $HE1" | tee -a $summaryfile
            echo "#lines = $lines" | tee -a $summaryfile
    ;;
   "HXM")   HXM1=$time
            HM1=`echo "$HXM1 - $HNM1" | bc -l`
            if [ $AFLAG == "1" -a $ADONE == "0" ]
            then
            #display Arbiter summary
               echo "TOTAL TIME FOR ARBITER = $ASUM1" | tee -a $summaryfile
               ADONE=1
            fi
            if [ $GFLAG == "1" -a $GDONE == "0" ]
            then
            #display Guest summary
               echo "TOTAL TIME FOR GUEST = $GSUM1" | tee -a $summaryfile
               GDONE=1
            fi
            HFLAG=1
            HSUM1=`echo "$HSUM1 + $HM1" | bc -l`
            echo "Time for Host Multiply = $HM1" | tee -a $summaryfile
            echo "#lines = $lines" | tee -a $summaryfile
    ;;

esac


done

if [ $AFLAG == "1" -a $ADONE == "0" ]
then
#display Arbiter summary
    echo "TOTAL TIME FOR ARBITER = $ASUM1" | tee -a $summaryfile
    ADONE=1
fi

if [ $GFLAG == "1" -a $GDONE == "0" ]
then
#display Guest summary
    echo "TOTAL TIME FOR GUEST = $GSUM1" | tee -a $summaryfile
    GDONE=1
fi

if [ $HFLAG == "1" -a $HDONE == "0" ]
then
#display Host summary
    echo "TOTAL TIME FOR HOST = $HSUM1" | tee -a $summaryfile
    HDONE=1
fi




#Find Grand total
if [ $AFLAG == "1" ]
then
   GRANDTOTAL1=`echo "$GRANDTOTAL1 + $ASUM1" | bc -l`
fi
if [ $GFLAG == "1" ]
then
   GRANDTOTAL1=`echo "$GRANDTOTAL1 + $GSUM1" | bc -l`
fi
if [ $HFLAG == "1" ]
then
   GRANDTOTAL1=`echo "$GRANDTOTAL1 + $HSUM1" | bc -l`
fi


echo "GRAND TOTAL = $GRANDTOTAL1" | tee -a $summaryfile
echo -e "\n" | tee -a $summaryfile
echo -e "\n" | tee -a $summaryfile





##### FOR the second Job

~/fate_paillier.sh $5 $6 $3

#Separate to LOG files
~/separating.sh $5 $6 $3


echo "Summary of $5 - $6 - $3 - $4" | tee -a $summaryfile
echo "*********************************************************************" | tee -a $summaryfile
echo -e "\n" | tee -a $summaryfile

ASUM2="0"
GSUM2="0"
HSUM2="0"
AFLAG="0"
ADONE="0"
GFLAG="0"
GDONE="0"
HFLAG="0"
HDONE="0"
GRANDTOTAL2="0"



for i in `find . -name *.LOG -path "*$5*" | sort`
do 
read -r  type time lines < <(~/myscript3.sh $i| cut -d"#" -f2,4,6 | awk -F "#" '{print substr($1, length($1)-6, 3),$3, $2  }')

case $type in
   "ANA")   ANA2=$time
    ;;
   "AND")   AND2=$time
    ;;
   "ANE")   ANE2=$time
    ;;
   "ANM")   ANM2=$time
    ;;
   "AXA")   AXA2=$time
            AA2=`echo "$AXA2 - $ANA2" | bc -l`
            AFLAG=1
            ASUM2=`echo "$ASUM2 + $AA2" | bc -l`
            echo "Time for Arbiter Add = $AA2" | tee -a $summaryfile
            echo "#lines = $lines" | tee -a $summaryfile
    ;;
   "AXD")   AXD2=$time
            AD2=`echo "$AXD2 - $AND2" | bc -l`
            AFLAG=1
            ASUM2=`echo "$ASUM2 + $AD2" | bc -l`
            echo "Time for Arbiter Decrypt = $AD2" | tee -a $summaryfile
            echo "#lines = $lines" | tee -a $summaryfile
    ;;
   "AXE")   AXE2=$time
            AE2=`echo "$AXE2 - $ANE2" | bc -l`
            AFLAG=1
            ASUM2=`echo "$ASUM2 + $AE2" | bc -l`
            echo "Time for Arbiter Encrypt = $AE2" | tee -a $summaryfile
            echo "#lines = $lines" | tee -a $summaryfile
    ;;
   "AXM")   AXM2=$time
            AM2=`echo "$AXM2 - $ANM2" | bc -l`
            AFLAG=1
            ASUM2=`echo "$ASUM2 + $AM2" | bc -l`
            echo "Time for Arbiter Multiply = $AM2" | tee -a $summaryfile
            echo "#lines = $lines" | tee -a $summaryfile
    ;;
   "GNA")   GNA2=$time
    ;;
   "GND")   GND2=$time
    ;;
   "GNE")   GNE2=$time
    ;;
   "GNM")   GNM2=$time
    ;;
   "GXA")   GXA2=$time
            GA2=`echo "$GXA2 - $GNA2" | bc -l`
            if [ $AFLAG == "1" -a $ADONE == "0" ]
            then
            #display Arbiter summary
               echo "TOTAL TIME FOR ARBITER = $ASUM2" | tee -a $summaryfile
               ADONE=1
            fi
            GFLAG=1
            GSUM2=`echo "$GSUM2 + $GA2" | bc -l`
            echo "Time for Guest Add = $GA2" | tee -a $summaryfile
            echo "#lines = $lines" | tee -a $summaryfile
    ;;
   "GXD")   GXD2=$time
            GD2=`echo "$GXD2 - $GND2" | bc -l`
            if [ $AFLAG == "1" -a $ADONE == "0" ]
            then
            #display Arbiter summary
               echo "TOTAL TIME FOR ARBITER = $ASUM2" | tee -a $summaryfile
               ADONE=1
            fi
            GFLAG=1
            GSUM2=`echo "$GSUM2 + $GD2" | bc -l`
            echo "Time for Guest Decrypt = $GD2" | tee -a $summaryfile
            echo "#lines = $lines" | tee -a $summaryfile
    ;;
   "GXE")   GXE2=$time
            GE2=`echo "$GXE2 - $GNE2" | bc -l`
            if [ $AFLAG == "1" -a $ADONE == "0" ]
            then
            #display Arbiter summary
               echo "TOTAL TIME FOR ARBITER = $ASUM2" | tee -a $summaryfile
               ADONE=1
            fi
            GFLAG=1
            GSUM2=`echo "$GSUM2 + $GE2" | bc -l`
            echo "Time for Guest Encrypt = $GE2" | tee -a $summaryfile
            echo "#lines = $lines" | tee -a $summaryfile
    ;;
   "GXM")   GXM2=$time
            GM2=`echo "$GXM2 - $GNM2" | bc -l`
            if [ $AFLAG == "1" -a $ADONE == "0" ]
            then
            #display Arbiter summary
               echo "TOTAL TIME FOR ARBITER = $ASUM2" | tee -a $summaryfile
               ADONE=1
            fi
            GFLAG=1
            GSUM2=`echo "$GSUM2 + $GM2" | bc -l`
            echo "Time for Guest Multiply = $GM2" | tee -a $summaryfile
            echo "#lines = $lines" | tee -a $summaryfile
    ;;
   "HNA")   HNA2=$time
    ;;
   "HND")   HND2=$time
    ;;
   "HNE")   HNE2=$time
    ;;
   "HNM")   HNM2=$time
    ;;
   "HXA")   HXA2=$time
            HA2=`echo "$HXA2 - $HNA2" | bc -l`
            if [ $AFLAG == "1" -a $ADONE == "0" ]
            then
            #display Arbiter summary
               echo "TOTAL TIME FOR ARBITER = $ASUM2" | tee -a $summaryfile
               ADONE=1
            fi
            if [ $GFLAG == "1" -a $GDONE == "0" ]
            then
            #display Guest summary
               echo "TOTAL TIME FOR GUEST = $GSUM2" | tee -a $summaryfile
               GDONE=1
            fi
            HFLAG=1
            HSUM2=`echo "$HSUM2 + $HA2" | bc -l`
            echo "Time for Host Add = $HA2" | tee -a $summaryfile
            echo "#lines = $lines" | tee -a $summaryfile
    ;;
   "HXD")   HXD2=$time
            HD2=`echo "$HXD2 - $HND2" | bc -l`
            if [ $AFLAG == "1" -a $ADONE == "0" ]
            then
            #display Arbiter summary
               echo "TOTAL TIME FOR ARBITER = $ASUM2" | tee -a $summaryfile
               ADONE=1
            fi
            if [ $GFLAG == "1" -a $GDONE == "0" ]
            then
            #display Guest summary
               echo "TOTAL TIME FOR GUEST = $GSUM2" | tee -a $summaryfile
               GDONE=1
            fi
            HFLAG=1
            HSUM2=`echo "$HSUM2 + $HD2" | bc -l`
            echo "Time for Host Decrypt = $HD2" | tee -a $summaryfile
            echo "#lines = $lines" | tee -a $summaryfile
    ;;
   "HXE")   HXE2=$time
            HE2=`echo "$HXE2 - $HNE2" | bc -l`
            if [ $AFLAG == "1" -a $ADONE == "0" ]
            then
            #display Arbiter summary
               echo "TOTAL TIME FOR ARBITER = $ASUM2" | tee -a $summaryfile
               ADONE=1
            fi
            if [ $GFLAG == "1" -a $GDONE == "0" ]
            then
            #display Guest summary
               echo "TOTAL TIME FOR GUEST = $GSUM2" | tee -a $summaryfile
               GDONE=1
            fi
            HFLAG=1
            HSUM2=`echo "$HSUM2 + $HE2" | bc -l`
            echo "Time for Host Encrypt = $HE2" | tee -a $summaryfile
            echo "#lines = $lines" | tee -a $summaryfile
    ;;
   "HXM")   HXM2=$time
            HM2=`echo "$HXM2 - $HNM2" | bc -l`
            if [ $AFLAG == "1" -a $ADONE == "0" ]
            then
            #display Arbiter summary
               echo "TOTAL TIME FOR ARBITER = $ASUM2" | tee -a $summaryfile
               ADONE=1
            fi
            if [ $GFLAG == "1" -a $GDONE == "0" ]
            then
            #display Guest summary
               echo "TOTAL TIME FOR GUEST = $GSUM2" | tee -a $summaryfile
               GDONE=1
            fi
            HFLAG=1
            HSUM2=`echo "$HSUM2 + $HM2" | bc -l`
            echo "Time for Host Multiply = $HM2" | tee -a $summaryfile
            echo "#lines = $lines" | tee -a $summaryfile
    ;;
esac

done

if [ $AFLAG == "1" -a $ADONE == "0" ]
then
#display Arbiter summary
    echo "TOTAL TIME FOR ARBITER = $ASUM2" | tee -a $summaryfile
    ADONE=1
fi
if [ $GFLAG == "1" -a $GDONE == "0" ]
then
#display Guest summary
    echo "TOTAL TIME FOR GUEST = $GSUM2" | tee -a $summaryfile
    GDONE=1
fi
if [ $HFLAG == "1" -a $HDONE == "0" ]
then
#display Host summary
    echo "TOTAL TIME FOR HOST = $HSUM2" | tee -a $summaryfile
    HDONE=1
fi

echo -e "\n" | tee -a $summaryfile
echo -e "\n" | tee -a $summaryfile


#Find Grand total
if [ $AFLAG == "1" ]
then
   GRANDTOTAL2=`echo "$GRANDTOTAL2 + $ASUM2" | bc -l`
fi
if [ $GFLAG == "1" ]
then
   GRANDTOTAL2=`echo "$GRANDTOTAL2 + $GSUM2" | bc -l`
fi
if [ $HFLAG == "1" ]
then
   GRANDTOTAL2=`echo "$GRANDTOTAL2 + $HSUM2" | bc -l`
fi


echo "GRAND TOTAL = $GRANDTOTAL2" | tee -a $summaryfile
echo -e "\n" | tee -a $summaryfile
echo -e "\n" | tee -a $summaryfile


echo -e "                         DIFFERENCE\n" | tee -a $summaryfile
echo -e "                         **********\n" | tee -a $summaryfile
echo "            In Arbiter Add:`echo $AA1 - $AA2 | bc -l`" | tee -a $summaryfile 
echo "            In Arbiter Decrypt:`echo $AD1 - $AD2 | bc -l`" | tee -a $summaryfile 
echo "            In Arbiter Encrypt:`echo $AE1 - $AE2 | bc -l`" | tee -a $summaryfile 
echo "            In Arbiter Mul:`echo $AM1 - $AM2 | bc -l`" | tee -a $summaryfile 
echo "      In Arbiter Total:`echo $ASUM1 - $ASUM2 | bc -l`" | tee -a $summaryfile 
echo -e "\n" | tee -a $summaryfile
echo "            In Guest Add:`echo $GA1 - $GA2 | bc -l`" | tee -a $summaryfile 
echo "            In Guest Decrypt:`echo $GD1 - $GD2 | bc -l`" | tee -a $summaryfile 
echo "            In Guest Encrypt:`echo $GE1 - $GE2 | bc -l`" | tee -a $summaryfile 
echo "            In Guest Mul:`echo $GM1 - $GM2 | bc -l`" | tee -a $summaryfile 
echo "      In Guest Total:`echo $GSUM1 - $GSUM2 | bc -l`" | tee -a $summaryfile  
echo -e "\n" | tee -a $summaryfile
echo "            In Host Add:`echo $HA1 - $HA2 | bc -l`" | tee -a $summaryfile 
echo "            In Host Decrypt:`echo $HD1 - $HD2 | bc -l`" | tee -a $summaryfile 
echo "            In Host Encrypt:`echo $HE1 - $HE2 | bc -l`" | tee -a $summaryfile 
echo "            In Host Mul:`echo $HM1 - $HM2 | bc -l`" | tee -a $summaryfile 
echo "      In Host Total:`echo $HSUM1 - $HSUM2 | bc -l`" | tee -a $summaryfile  
echo -e "\n" | tee -a $summaryfile

echo -e "\n\n" | tee -a $summaryfile
echo "In Grand Total:`echo $GRANDTOTAL1 - $GRANDTOTAL2 | bc -l`" | tee -a $summaryfile
echo -e "\n" | tee -a $summaryfile
echo "Percentage GAIN in Grand Total:`echo \( $GRANDTOTAL1 - $GRANDTOTAL2 \) / $GRANDTOTAL1 \* 100 | bc -l`" | tee -a $summaryfile
echo -e "\n" | tee -a $summaryfile
echo -e "-------------------------------------------------------------------------------------\n\n" | tee -a $summaryfile
