class Gubbins < Formula
  # cite Croucher_2015: "https://doi.org/10.1093/nar/gku1196"
  desc "Detect recombination in bacteria whole genome alignments"
  homepage "https://github.com/sanger-pathogens/gubbins"
  url "https://github.com/sanger-pathogens/gubbins/archive/v2.4.1.tar.gz"
  sha256 "df0f6f475ef402d6f2f67abb870dcb2c59f3333bf6a00af76251bb102f63e17b"

  depends_on "autoconf"   => :build
  depends_on "automake"   => :build
  depends_on "check"      => :build
  depends_on "libtool"    => :build
  depends_on "pkg-config" => :build

  depends_on "fasttree"
  depends_on "python"
  depends_on "raxml"
  
  uses_from_macos "zlib"

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    cd "python" do
      system "python3", *Language::Python.setup_install_args(libexec)
    end
    (bin/"run_gubbins.py").write_env_script libexec/"bin/run_gubbins.py",
      :PYTHONPATH => Dir[libexec/"lib/python*/site-packages"].first
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gubbins -h 2>&1")
    assert_match version.to_sm shell_output("#{bin}/run_gubbins.py --version 2>&1")
  end
end
