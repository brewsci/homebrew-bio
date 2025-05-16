class Msms < Formula
  # cite "Sanner_1996: https://doi.org/10.1002/(SICI)1097-0282(199603)38:3<305::AID-BIP4>3.0.CO;2-Y"
  desc "Compute molecular surfaces (MSMS)"
  homepage "https://ccsb.scripps.edu/msms/"
  version "2.6.1"

  # Only post-build binaries and accompanying files are available
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://ccsb.scripps.edu/msms/download/942/"
      sha256 "87679f0666b388dfcf022ee2e8caace93d5953ef3d67689fd3fafc33eb9c25d3"
    else
      url "https://ccsb.scripps.edu/msms/download/950/"
      sha256 "aa9c6fcdffd78f20a48990d7ce6cbe19394bb88071e2a9cc26c675171eccfcc8"
    end
  elsif OS.linux?
    url "https://ccsb.scripps.edu/msms/download/933/"
    sha256 "5f0ca50360b5938e74c538e0399d582abc4a40ef4cf410e66f31a1f91e6e3e1f"
  end

  on_linux do
    depends_on "awk"
  end

  # Due to the different directory structure when decompressing
  if OS.mac?
    patch :p1, :DATA
  elsif OS.linux?
    patch :p0, :DATA
  end

  def install
    inreplace "pdb_to_xyzr",
              'numfile = "./atmtypenumbers"',
              "numfile = \"#{pkgshare}/atmtypenumbers\""
    inreplace "pdb_to_xyzrn",
              'numfile = "./atmtypenumbers"',
              "numfile = \"#{pkgshare}/atmtypenumbers\""

    bin.install "pdb_to_xyzr", "pdb_to_xyzrn"
    if OS.mac?
      if Hardware::CPU.arm?
        bin.install "msms_Arm64_2.6.1" => "msms"
      else
        bin.install "msms.x86_64Darwin.2.6.1" => "msms"
      end
    elsif OS.linux?
      bin.install "msms.x86_64Linux2.2.6.1" => "msms"
    end

    man1.install "msms.1"
    doc.install "msms.html"
    pkgshare.install "1crn.pdb", "1crn.xyzr", "atmtypenumbers"
    prefix.install_metafiles
  end

  test do
    ouput_pdb_to_xyzr = shell_output("cat #{pkgshare}/1crn.pdb | #{bin}/pdb_to_xyzr")
    assert_match "12.703    4.973   10.746 1.40", ouput_pdb_to_xyzr
    ouput_pdb_to_xyzrn = shell_output("cat #{pkgshare}/1crn.pdb | #{bin}/pdb_to_xyzrn")
    assert_match "12.703000 4.973000 10.746000 1.400000 1 OXT_ASN_46", ouput_pdb_to_xyzrn
    system "#{bin}/msms", "-if", "#{pkgshare}/1crn.xyzr", "-of", "1crn"
    assert_match "25.578    13.692     9.815", (testpath/"1crn.vert").read
    assert_match "1302   1306   1309  1   1304", (testpath/"1crn.face").read
  end
end
__END__
--- pdb_to_xyzr	2015-10-27 17:18:46.425473839 -0400
+++ pdb_to_xyzr	2015-10-27 17:19:43.017473698 -0400
@@ -28,7 +28,7 @@
 	shift
 	fi
 fi
-nawk 'BEGIN{
+awk 'BEGIN{
 	# read radius table and patterns from supplied file
 	npats=0
 	numfile = "./atmtypenumbers"
  --- pdb_to_xyzrn	2015-10-27 17:18:52.833473823 -0400
  +++ pdb_to_xyzrn	2015-10-27 17:19:29.713473731 -0400
  @@ -28,7 +28,7 @@
   	shift
   	fi
   fi
  -nawk 'BEGIN{
  +awk 'BEGIN{
   	# read radius table and patterns from supplied file
   	npats=0
   	numfile = "./atmtypenumbers"
  @@ -80,10 +80,13 @@


   	resnum=substr($0,23,4);
  +	chain=substr($0,21,2);

   	# trim any blanks
   	gsub(" ", "", resname);
   	gsub(" ", "", aname);
  +	gsub(" ", "", resnum);
  +	gsub(" ", "", chain);

   	for(pat=0;pat<npats;pat++) {
   		if( aname ~ atmpat[pat] && resname ~ respat[pat] ) break
  @@ -96,7 +99,7 @@
   		  | "cat 1>&2" # write to stderr
   		print x,y,z,0.01
   		}
  -	else printf("%f %f %f %f %d %s_%s_%d\n", x, y, z, \
  -	  ('$h_select'== 5 ? united_rad[atmnum[pat]]:explicit_rad[atmnum[pat]]), 1, aname, resname, resnum);
  +	else printf("%f %f %f %f %d %s_%s_%d_%s\n", x, y, z, \
  +	  ('$h_select'== 5 ? united_rad[atmnum[pat]]:explicit_rad[atmnum[pat]]), 1, aname, resname, resnum, chain);
   	next;
   	}' $*
