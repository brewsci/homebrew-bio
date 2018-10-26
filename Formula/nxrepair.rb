class Nxrepair < Formula
  # cite Murphy_2015: "https://doi.org/10.7717/peerj.996"
  desc "Correct errors in genome sequence assemblies using mate pair reads"
  homepage "https://github.com/rebeccaroisin/nxrepair"
  url "https://files.pythonhosted.org/packages/c2/3a/f0b3e44a96c79843902ab7a2500a613e3b2530b7596343ba3f726cb105cb/nxrepair-0.13.tar.gz"
  sha256 "80efacb4c9e4213060e95e1a1bfec548af59c2ad79b7a91bcc023330040bb1b6"
  revision 1
  head "https://github.com/rebeccaroisin/nxrepair.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "315fee829379b9f5bd9096c5b4d24475ab6f5f58fbc857919b1681393998b92e" => :sierra
    sha256 "9dd38cc1cfe647dd8172b3fa0cd49649b9447de8f6b47e433bdba2564e0be0b0" => :x86_64_linux
  end

  depends_on "numpy"
  depends_on "python@2"
  depends_on "scipy"
  unless OS.mac?
    # For matplotlib
    depends_on "pkg-config" => :build
    depends_on "freetype"
    depends_on "libpng"
  end

  def install
    ENV.prepend_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    args = []
    args << "--no-binary=matplotlib" unless OS.mac?
    system "pip2", "install", "--prefix=#{libexec}", "matplotlib", "pysam", *args
    system "python2", *Language::Python.setup_install_args(prefix)
    bin.env_script_all_files libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"]
  end

  test do
    assert_match "usage", shell_output("#{bin}/nxrepair --help")
  end
end
