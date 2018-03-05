class MagicBlast < Formula
  desc "Magic BLAST read mapper"
  homepage "https://ncbi.github.io/magicblast/"
  if OS.mac?
    url "ftp://ftp.ncbi.nlm.nih.gov/blast/executables/magicblast/1.3.0/ncbi-magicblast-1.3.0-x64-macosx.tar.gz"
    sha256 "4ed5f93435894e3e121507d0e403b3065171667fa72d2ab39ee550d07265b880"
  elsif OS.linux?
    url "ftp://ftp.ncbi.nlm.nih.gov/blast/executables/magicblast/1.3.0/ncbi-magicblast-1.3.0-x64-linux.tar.gz"
    sha256 "9247ebcd14e4f0ca1e710d3b5fd228ff2c9d61a11acac8862136758763e3f3d6"
  end

  unless OS.mac?
    depends_on "patchelf" => :build
    depends_on "bzip2"
    depends_on "libxml2"
    depends_on "zlib"
  end

  depends_on "libidn"

  def install
    File.rename("bin/makeblastdb", "bin/magicblast-makeblastdb")
    bin.install Dir["bin/*"]
    unless OS.mac?
      Dir["#{bin}/*"].each do |exe|
        system "patchelf",
               "--set-interpreter", HOMEBREW_PREFIX/"lib/ld.so",
               "--set-rpath", HOMEBREW_PREFIX/"lib",
               exe
      end
    end
  end

  def caveats
    <<~EOS
      The 'makeblastdb' command has been installed as 'magicblast-makeblastdb'
      to avoid conflicts with the BLAST+ executables from the 'blast' formula.
    EOS
  end

  test do
    assert_match "BLAST", shell_output("#{bin}/magicblast 2>&1", 1)
  end
end
