param (
    
        [string]$baseUri
    )
    
    #Get the bits for the HANA installation and copy them to C:\SAPbits\SAP_HANA_STUDIO\
    $hanadest = "C:\SaPBits"
    $sapcarUri = $baseUri + "/SaPBits/SAP_HANA_STUDIO/sapcar.exe" 
    $hanastudioUri = $baseUri + "/SaPBits/SAP_HANA_STUDIO/IMC_STUDIO2_223_0-80000353.SAR" 
    $jreUri = $baseUri + "/SaPBits/SAP_HANA_STUDIO/serverjre-9.0.4_windows-x64_bin.tar.gz"
    $puttyUri = "https://the.earth.li/~sgtatham/putty/latest/w64/putty-64bit-0.70-installer.msi"
    $7zUri = "http://www.7-zip.org/a/7z1701-x64.msi"
    $sapcardest = "C:\SaPBits\SAP_HANA_STUDIO\sapcar.exe"
    $hanastudiodest = "C:\SaPBits\SAP_HANA_STUDIO\IMC_STUDIO2_223_0-80000353.SAR"
    $jredest = "C:\Program Files\serverjre-9.0.4_windows-x64_bin.tar.gz"
    $puttydest = "C:\SaPBits\SAP_HANA_STUDIO\putty-64bit-0.70-installer.msi"
    $7zdest = "C:\Program Files\7z.msi"
    $jrepath = "C:\Program Files"
    $hanapath = "C:\SaPBits\SAP_HANA_STUDIO"
    if((test-path $hanadest) -eq $false)
    {
        New-Item -Path $hanadest -ItemType directory
        New-item -Path $hanapath -itemtype directory
    }
    write-host "downloading files"
    Invoke-WebRequest $sapcarUri -OutFile $sapcardest
    Invoke-WebRequest $hanastudioUri -OutFile $hanastudiodest
    Invoke-WebRequest $jreUri -OutFile $jredest
    Invoke-WebRequest $7zUri -OutFile $7zdest
    Invoke-WebRequest $puttyUri -OutFile $puttydest
    
    write-host "installing 7zip and extracting JAVA"
    cd $jrepath
    .\7z.msi /quiet
    cd "C:\Program Files\7-Zip\"
    .\7z.exe e "C:\Program Files\serverjre-9.0.4_windows-x64_bin.tar.gz" "-oC:\Program Files"
    .\7z.exe x -y "C:\Program Files\serverjre-9.0.4_windows-x64_bin.tar" "-oC:\Program Files"
    
    cd $hanapath
    write-host "installing PuTTY"
    .\putty-64bit-0.70-installer.msi /quiet
    
    write-host "extracting and installing HANA Studio"
    .\sapcar.exe -xfv IMC_STUDIO2_223_0-80000353.SAR
    
    set PATH=%PATH%C:\Program Files\jdk-9.0.4\bin;
    set HDB_INSTALLER_TRACE_FILE=C:\Users\testuser\Documents\hdbinst.log
    cd C:\SaPBits\SAP_HANA_STUDIO\SAP_HANA_STUDIO\
    .\hdbinst.exe -a C:\SaPBits\SAP_HANA_STUDIO\SAP_HANA_STUDIO\studio -b --path="C:\Program Files\sap\hdbstudio"
