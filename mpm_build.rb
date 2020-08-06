
uname=`uname`.strip
datestr=`date "+%Y%m%d%H%M"`.strip


print "detecting arch: #{uname}\n"

basename=nil

if uname == "Darwin" then
  print "Darwin detected\n"
  osxver=`sw_vers -productVersion` # ex. 10.15
  basename="libuv-macos#{osxver}-#{datestr}"
elsif uname=="Linux" then
  print "linux detected\n"
  el7=`grep -o "release 7" /etc/redhat-release`.strip
  if el7=="release 7" then
    print "el7 detected\n"
    basename="libuv-el7-#{datestr}"
  end
  ubu=`lsb_release -i -s`.strip
  if ubu=="Ubuntu" then
    print "ubuntu detected\n"
    ubuver=`lsb_release -r -s`.strip
    basename="libuv-ubuntu#{ubuver}-#{datestr}"
  end
end

if !basename then
  print "no arch detected, quitting\n"
  exit
end

print "basename:'#{basename}'\n"

def sys(cmd)
  result=system(cmd)
  if !result then
    print "command failed, quitting\n"
    exit 1
  end
end

sys("sh autogen.sh")
sys("./configure")
sys("make CFLAGS=-fPIC")
sys("mkdir /tmp/#{basename}")
sys("cp -r include /tmp/#{basename}/")
sys("cp .libs/libuv.a /tmp/#{basename}/")
sys("git log | head -1 | awk '{print $2}' > /tmp/#{basename}/git_revision.txt")
sys("cd /tmp; zip -r #{basename}.zip #{basename}")
sys("cd /tmp; aws s3 cp #{basename}.zip s3://monobit/libuv/#{basename}.zip")


