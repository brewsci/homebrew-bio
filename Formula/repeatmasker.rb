class Repeatmasker < Formula
  include Language::Python::Virtualenv
  include Language::Python::Shebang

  desc "Program that screens DNA sequences for interspersed repeats"
  homepage "https://www.repeatmasker.org/RepeatMasker/"
  url "https://www.repeatmasker.org/RepeatMasker/RepeatMasker-4.1.6.tar.gz"
  sha256 "85c8bf61dd8411d140674cfa74e7642b41878fd63a7a779845e35162828f0d74"
  license "OSL-2.1"

  depends_on "cmake" => :build
  depends_on "cpanminus" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "blast"
  depends_on "brewsci/bio/rmblast"
  depends_on "brewsci/bio/trf"
  depends_on "hdf5"
  depends_on "hmmer"
  depends_on "python@3.12"

  uses_from_macos "perl"

  on_linux do
    depends_on "patchelf" => :build
  end

  resource "h5py" do
    url "https://files.pythonhosted.org/packages/52/8f/e557819155a282da36fb21f8de4730cfd10a964b52b3ae8d20157ac1c668/h5py-3.11.0.tar.gz"
    sha256 "7b7e8f78072a2edec87c9836f25f34203fd492a4475709a18b417a33cfb21fa9"
  end

  resource "repbase" do
    url "https://github.com/yjx1217/RMRB/raw/master/RepBaseRepeatMaskerEdition-20181026.tar.gz"
    sha256 "213a15f9dafbd1302b1d544b82b9141eacab1c5be5b36233da7446f901375b2e"
  end

  resource "daterepeats" do
    url "https://raw.githubusercontent.com/rmhubley/RepeatMasker/master/DateRepeats"
    sha256 "768fc9c4701938062a114aa6392a291b50c838b9a596b15015711cf52ff92731"
  end

  def python3
    "python3.12"
  end

  def perl
    which("perl")
  end

  def install
    hmmer_bin = Formula["hmmer"].bin
    # Install Python dependencies
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resource("h5py")

    libexec.install Dir["*"]
    (libexec/"Libraries").install resource("repbase")
    # Download missing DateRepeats script
    libexec.install resource("daterepeats")
    chmod 0755, libexec/"DateRepeats"

    ENV["PERL5LIB"] = libexec/"lib/perl5"
    system "cpanm", "--self-contained", "-l", libexec, "Text::Soundex"
    ENV["PYTHONPATH"] = libexec/"lib/python3.12/site-packages"
    (bin/"RepeatMasker").write_env_script(libexec/"RepeatMasker", PERL5LIB:   ENV["PERL5LIB"],
                                                                  PYTHONPATH: ENV["PYTHONPATH"])
    # always use python3 installed in libexec/bin directory
    inreplace libexec/"configure", "python3 -c", "./bin/python3 -c"
    # fix for Dfam 3.8, https://github.com/rmhubley/RepeatMasker/pull/269
    inreplace libexec/"famdb_classes.py", "[tax_id, tree]", "[int(tax_id), tree]"
    rewrite_shebang detected_python_shebang, libexec/"famdb.py"
  end

  def caveats
    <<~EOS
      RepeatMasker was installed with a minimal repeat library. To download
      the complete libraries, follow the instructions here:
        #{libexec}/INSTALL
      The default aligner is RMBlast. Change this by running:
        cd #{libexec}
        export PYTHONPATH=#{libexec}/lib/python3.12/site-packages
        ./configure -perlbin #{perl} -trf_prgm #{Formula["trf"].bin/"trf"} -rmblast_dir #{Formula["rmblast"].bin} \\
        -hmmer_dir #{hmmer_bin} -libdir #{libexec}/Libraries
    EOS
  end

  test do
    # Cannot test without the full repeat library
    assert_match "RepeatMasker version", shell_output("#{bin}/RepeatMasker -help")
  end
end
