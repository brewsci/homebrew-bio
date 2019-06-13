class Pcap < Formula
  desc "Assemble capillary sequence reads"
  homepage "http://seq.cs.iastate.edu/pcap.html"
  if OS.mac?
    url "http://seq.cs.iastate.edu/PCAP/pcap.rep.osx.intel64.tar"
    sha256 "dcf4d59ba1226ebac0ac604af0eb9cee246742bbd7bce2fd36e115ed0335c014"
  elsif OS.linux?
    url "http://seq.cs.iastate.edu/PCAP/pcap.rep.linux.xeon64.tar"
    sha256 "568ead31c0a957ec6a7d3b83fa3f18d5b9516ff5b785f1028b63d24de1d940e1"
  end
  version "2005-06-07"

  unless OS.mac?
    depends_on "patchelf" => :build
    depends_on "perl"
  end

  def install
    doc.install %w[README Distributed.doc Doc Doc.rep autopcap.doc]
    bin.install Dir["*"]
    elf = %w[bclean bclean.rep bconsen bcontig bcontig.rep
             bdocs bdocs.rep bform bpair formcon2 n50
             pcap pcap.rep trim2 trim3 xstat]
    if OS.linux?
      elf.each do |exe|
        system "patchelf",
          "--set-interpreter", HOMEBREW_PREFIX/"lib/ld.so",
          "--set-rpath", HOMEBREW_PREFIX/"lib",
          bin/exe
      end
    end
  end

  test do
    assert_match "File_of_file_names", shell_output("#{bin}/pcap 2>&1", 1)
  end
end
