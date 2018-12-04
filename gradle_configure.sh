#!/usr/bin/env bash

MAVEN_USERNAME="mvn_user"
MAVEN_PASSWORD="mvn_pass"
EMAIL_USERNAME="mail_user"
EMAIL_PASSWORD="mail_pass"
EMAIL_HOST="mail_host"
EMAIL_TO="mail_to"
BUILD_GRADLE_FILE="../app/build.gradle"

FILES=`(pwd)`/publish-apk.gradle


replay_set(){
    sed -i "s#@@$1@@#$2#g" $3
}


gradle_include_set(){

EXIST=`grep  -w $FILES  $1`

if [[  "${EXIST// }" ]]
    then
    echo "Gradle is configuration"

else

    sed -i '1 iapply from: "'$FILES'"' $1
    echo "Gradle compile configuration"
fi 

}



create_include_conf(){
    cp $FILES.tpl $FILES
    cp git_log.sh ../git_log.sh
    replay_set "MAVEN_USERNAME" $MAVEN_USERNAME $FILES
    replay_set "MAVEN_PASSWORD" $MAVEN_PASSWORD $FILES
    replay_set "EMAIL_USERNAME" $EMAIL_USERNAME $FILES
    replay_set "EMAIL_PASSWORD" $EMAIL_PASSWORD $FILES
    replay_set "EMAIL_HOST" $EMAIL_HOST $FILES
    replay_set "EMAIL_TO" $EMAIL_TO $FILES
}





gradle_include_set  $BUILD_GRADLE_FILE
[ -f $FILES ] && echo "File $FILES exists" || create_include_conf






