{ pkgs, ... }: {

  environment.loginShellInit = ''                                                                                                    
   # disable for user root and non-interactive tools                                                                                
   if [ `id -u` != 0 ]; then                                                                                                        
     if [ "x''${SSH_TTY}" != "x" ]; then                                                                                            
       ${pkgs.fastfetch}/bin/fastfetch                                                                                                         
     fi                                                                                                                             
   fi                                                                                                                               
  '';
}