apply plugin: 'maven-publish'



configurations { antClasspath }
dependencies {
    antClasspath 'ant:ant-javamail:1.6.5'
    antClasspath 'javax.activation:activation:1.1.1'
    antClasspath 'javax.mail:mail:1.4.7'
}
ClassLoader antClassLoader = org.apache.tools.ant.Project.class.classLoader
configurations.antClasspath.each { File jar ->
    println "Adding to ant classpath : " + jar.absolutePath
    antClassLoader.addURL(jar.toURI().toURL())
}




task mailSend {

 Set<String>  messageSet = new HashSet<String>()

 def proc = "./git_log.sh".execute();
 def outputStream = new StringBuffer();
 proc.waitForProcessOutput(outputStream, System.err);
 messageSet << outputStream.toString();
 

   doLast {
           android.applicationVariants.all { variant ->
           variant.outputs.each { output ->
           messageSet <<" -BetOlimp-Africa ${output.baseName} ${versionName} URL:   https://nexus.it-olimp-tomsk.com/repository/africa-maven/app/BetOlimp-Africa/BetOlimp-Africa-${output.baseName}-"+getDate()+"/${versionName}/BetOlimp-Africa-${output.baseName}-"+getDate()+"-${versionName}.apk"
	}
    }


    def mailParams = [
            mailhost       : "@@EMAIL_HOST@@",
            mailport       : "465",
            subject        :  "BetOlimp-Africa ${versionName} "+getDate()+"",
            messagemimetype: "text/plain",
            user           : "@@EMAIL_USERNAME@@",
            password       : "@@EMAIL_PASSWORD@@",
            enableStartTLS : "true",
            ssl            : "true"
    ]
    println 'Mail Sending Start..'
    ant.mail(mailParams) {
        from(address: '@@EMAIL_USERNAME@@')
        to(address: '@@EMAIL_TO@@')
        message ( messageSet.toString().replace(",","\n"));
     }

   }


}




publishing {
    repositories {
        maven {
            url "@@MAVEN_URL@@"
            credentials {
                username "@@MAVEN_USERNAME@@"
                password "@@MAVEN_PASSWORD@@"
            }
        }
    }
    publications {
        android.applicationVariants.all { variant ->
            variant.outputs.each { output ->
                create("apk${variant.name.capitalize()}", MavenPublication) {
		    groupId "app.BetOlimp-Africa"
                    artifactId "BetOlimp-Africa-${output.baseName}-"+getDate()+""
                    version "${variant.versionName}"
                    artifact(output.outputFile)

                }

            }

        }

    }


}



