#!/bin/bash

menu_choice=""
record_file="Student.txt"
temp_file=/tmp/txt.$$
touch $temp_file; chmod 644 $temp_file
trap 'rm -f $temp_file' EXIT

delay(){

    n=0
    while [ $n -le 2 ]
    do
        printf ". "
        sleep 0.2
          (( n++ ))
    done
}

get_return(){
printf '\n\n\tPress Return to continue...'
read x
return 0
}

get_confirm(){
printf '\nAre you sure? '
while true
do
  read x
  case "$x" in
      y|yes|Y|Yes|YES)
      return 0;;
      n|no|N|No|NO)
          printf '\ncancelled\n'
          return 1;;
      *) printf 'Please enter yes or no';;
  esac
done
}

set_menu_choice(){
clear
# printf 'Options:-'
printf "\n\t\t\t   " 
date

	printf "\t\t:::::::::::::::::::::::::::::::::::::::::::::::::::::::\n"
	printf "\t\t::\t\t\t\t\t\t     ::\n"
	printf "\t\t:.  ----Student Registaration System Admin Panel---- .:\n"
	printf "\t\t::\t\t\tV 1.0.0\t\t\t     ::\n"
    printf "\t\t::\t\t\t\t\t\t     ::\n"
	printf "\t\t:::::::::::::::::::::::::::::::::::::::::::::::::::::::\n"

printf "\t\t::\t\t\t\t\t\t     ::\n"
printf "\t\t::\t\t1.Add a Student\t\t\t     ::\n"
printf "\t\t::\t\t2.View List\t\t\t     ::\n"
printf "\t\t::\t\t3.Search for a Student\t\t     ::\n"
printf "\t\t::\t\t4.Blacklist a Student\t\t     ::\n"
printf "\t\t::\t\t5.Remove from Blacklist\t\t     ::\n"
printf "\t\t::\t\t6.Delete a Student\t\t     ::\n"
printf "\t\t::\t\t7.Group Members\t\t\t     ::\n"
printf "\t\t::\t\t0.Exit\t\t\t\t     ::\n"


printf "\t\t::\t\t\t\t\t\t     ::\n"
printf "\t\t:::::::::::::::::::::::::::::::::::::::::::::::::::::::\n\n"
printf 'Enter the choice: '
read menu_choice
return
}

display(){
printf "\t\t:::::::::::::::::::::::::::::::::::::::::::::::::::::::\n"
	printf "\t\t::\t\t\t\t\t\t     ::\n"
	printf "\t\t:.  ----Student Registaration System Admin Panel---- .:\n"
	printf "\t\t::\t\t\tV 1.0.0\t\t\t     ::\n"
	printf "\t\t::\t\t\t\t\t\t     ::\n"
	printf "\t\t:::::::::::::::::::::::::::::::::::::::::::::::::::::::\n"
}

insert_record(){
echo -e "$*"$'\r' >>$record_file  # add new student record in a new line
#echo -e ""
echo -e "\nStudent has been successfully added!\n"
return
}

# Add a student

addStudent(){
av="Yes"
#prompt for information
clear
display
printf "\n\n\n\t\t\t==========Registration of a Student==========\n"
printf "\n\tPlease add the following Student information \n"

printf 'Enter First Name: '
read tmp
firstNm=${tmp%%,*}

printf 'Enter Last Name: '
read tmp
lastNm=${tmp%%,*}

printf 'Enter Id of the student: '
read tmp
idnum=${tmp%%,*}

printf 'Enter Department: '
read tmp
dept=${tmp%%,*}

# Ask user if he wants to add the info of the student
printf '\nAdding the following info? \t\t'
printf "$firstNm\t$lastNm\t$idnum\t$dept\n"

#If true add to Student.txt
if get_confirm; then
   insert_record "$firstNm,$lastNm,$dept,$idnum,$av" 
   
fi

return
}

viewList(){
clear
display
echo -e "\n\n\t\t\t-----------Student Data-----------\n"
cat $record_file
get_return
return
}
groupMembers(){
   clear 
  display
  echo -e "\n\n\t\t\t====================Developers====================\n"
  echo -e "\t\t\t    1. Samuel Amsalu  --------------- ID 1036/10\n"
  echo -e "\t\t\t    2. Yididya Samuel --------------- ID 1256/10\n"
  echo -e "\t\t\t==================================================\n"
  get_return
  return
}

search(){
  clear
  display  
  #echo "Enter student to find:"
  printf "\n\n \t\t Search For a Registered Student using First Name\n\n"
  read -p "Enter student to find: " st2find
  grep $st2find $record_file > $temp_file

  # set $(wc -l $temp_file)
  # linesfound=$1
  linesfound=`cat $temp_file|wc -l`

  case `echo $linesfound` in
  0)    echo "Sorry, nothing found"
        get_return
        return 0
        ;;
  *)    echo "Found the following"
        cat $temp_file
        get_return
        return 0
  esac
return
}

search_to_delete(){
    read -p "Enter the first name of the student to delete: " st2delete
  grep $st2delete $record_file > $temp_file

  # set $(wc -l $temp_file)
  # linesfound=$1
  linesfound=`cat $temp_file|wc -l`

  case `echo $linesfound` in
  0)    return 1
        ;;
  *)    return 0
  esac
return
}

deleteRecord(){
    clear
    display
  printf "\n\n \tDeleting a student requires adminstrator privilage!\n\n"
  #printf "Enter Adminstrator password to continue"
  read -sp "Enter Adminstrator password to continue: " password
  if [ $password == "mypassword" ]
  then
      clear
      display
      printf "\n\n\n\t\t =====Adminstrator Mode=====\n\n\n"
      #printf "Enter the first name of the student to delete: "
      #read name
      if search_to_delete
      then
          if get_confirm; 
          then
              sed -i "/$st2delete/d" Student.txt
              printf "Student $st2delete is Deleted!\n"
          else 
          get_return    
          fi
      else
        printf "\nStudent Not Found!\n"
        #get_return
      fi          
  else 
       printf " \n Incorrect password! \n"
  fi
  get_return
  return
}

blk(){
  clear
    display
  printf "\n\n \tBlackListing a student requires adminstrator privilage!\n\n"
  #printf "Enter Adminstrator password to continue"
  read -sp "Enter Adminstrator password to continue: " password
  if [ $password == "mypassword" ]
  then
      clear
      display
      printf "\n\n\n\t\t =====Adminstrator Mode=====\n\n\n"

     read -p "Enter the students Id you BlackList " blkid
     #######################################
     grep $blkid $record_file >$temp_file

  # set $(wc -l $temp_file)
  # linesfound=$1
  linesfound=`cat $temp_file|wc -l`

  case `echo $linesfound` in
  0)    echo "Sorry, Student with Id $blkid not Found!"
         get_return
         return 0
            ;;
  *)    echo "Found the following"
        cat $temp_file
	sed -i "s/$blkid,Yes/$blkid,No/g" $record_file
	echo -e "\nStudent with Id $blkid has been added to Black List!"
    get_return
    return 0
  esac
     #######################################

     #sed -i "s/$blkid,Yes/$blkid,No/g" $record_file
      #echo -e "\nStudent with Id $blkid has been added to Black List!"
      
  else
      printf "\n Incorrect Password!\n"
  fi
  get_return              
  return    
  
}
unblk(){
  clear
  display
  printf "\n\n \t Removing a student from a black list requires adminstrator privilage!\n\n"
  #printf "Enter Adminstrator password to continue"
  read -sp "Enter Adminstrator password to continue: " password
  if [ $password == "mypassword" ]
  then
      clear
      display
      printf "\n\n\n\t\t =====Adminstrator Mode=====\n\n\n"
      read -p "Enter the students Id you want to remove from blackList: " uid
      
      ######################################
       grep $uid $record_file >$temp_file

  # set $(wc -l $temp_file)
  # linesfound=$1
  linesfound=`cat $temp_file|wc -l`

  case `echo $linesfound` in
  0)    echo "Sorry, Student with Id $uid not Found!"
         get_return
         return 0
            ;;
  *)    echo "Found the following"
        cat $temp_file
	    sed -i "s/$uid,No/$uid,Yes/g" $record_file
	    echo -e "\nStudent with Id $uid has been removed from Black List!"
        get_return
        return 0
  esac
      ######################################

     #sed -i "s/$uid,No/$uid,Yes/g" $record_file
      #echo -e "\nStudent with Id $uid has been removed from Black List!"
    
  else
      printf "\n Incorrect Password!\n"
  fi
  get_return
              
  return

}



rm -f $temp_file
if [!-f $record_file];then
touch $record_file
fi

clear
printf '\n\n\n\n\n\n'
printf '\t=========Student Registration System Admin Panel========= \n\n'
printf '\n\t\t\t\t Loading'
delay


exit="n"
while [ "$exit" != "y" ];
do

#funtion call for choice
set_menu_choice
case "$menu_choice" in
1) addStudent;;
2) viewList;;
3) search;;
4) blk;;
5) unblk;;
6) deleteRecord;;
7) groupMembers;;
0) exit=y;;
*) printf "\nInvalid input!\n";;
esac
done
# Tidy up and leave

rm -f $temp_file
printf "\n\n\n \t\t===========Good Bye!===========\n"
printf "\n\n\tExiting"
delay
echo -e "\n\n"
clear

exit 0
