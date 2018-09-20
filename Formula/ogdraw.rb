class Ogdraw < Formula
  # cite Lohse_2007: "https://doi.org/10.1007/s00294-007-0161-y"
  # cite Lohse_2013: "https://doi.org/10.1093/nar/gkt289"
  desc "OrganellarGenomeDRAW: convert GenBank files to graphical maps"
  homepage "http://ogdraw.mpimp-golm.mpg.de/"
  url "https://chlorobox.mpimp-golm.mpg.de/GeneMap-1.1.1.tar.gz"
  sha256 "d850aabd3c273e965ece148178a60ec9a097aad6cfa08c94a0e06a924fc9e063"

  depends_on "cpanminus" => :build
  depends_on "bioperl"
  depends_on "imagemagick@6" # for Image::Magick

  def install
    ENV.prepend_path "PERL5LIB", Formula["bioperl"].libexec/"lib/perl5"
    ENV.prepend_path "PERL5LIB", libexec/"lib/perl5"
    ENV.prepend_path "PERL5LIB", lib/"perl5/site_perl"

    system "cpanm", "--force", "--self-contained", "-l", libexec, "Image::Magick"
    system "cpanm", "--self-contained", "-l", libexec, "PostScript::Simple", "XML::Generator"

    system "perl", "Makefile.PL", "PREFIX=#{prefix}"
    system "make", "pure_install"
    bin.install "irscan/bin/irscan_linux_x86" => "irscan" if OS.linux?

    libexec.install bin/"drawgenemap"
    (bin/"drawgenemap").write_env_script libexec/"drawgenemap", :PERL5LIB => ENV["PERL5LIB"]
  end

  test do
    assert_match "Usage", shell_output("#{bin}/drawgenemap --help")
  end
end
