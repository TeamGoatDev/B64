New-Item -ItemType directory -path C:\DFSRoots\B64
New-SmbShare -name "B64_DFSadmin"

new-DfsnRoot -path("\\"+$nomDom+"\B64_DFSadmin")`
             -targetPath("\\"+   