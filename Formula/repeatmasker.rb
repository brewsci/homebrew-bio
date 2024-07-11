class Repeatmasker < Formula
  include Language::Python::Virtualenv

  desc "Program that screens DNA sequences for interspersed repeats"
  homepage "https://www.repeatmasker.org/RepeatMasker/"
  url "https://www.repeatmasker.org/RepeatMasker/RepeatMasker-4.1.6.tar.gz"
  sha256 "85c8bf61dd8411d140674cfa74e7642b41878fd63a7a779845e35162828f0d74"
  license "GPL-2.0-only"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any_skip_relocation, x86_64_linux: "366fc75de9aa4f245d4386ec226d39c27136e827712d8b8b75d3ae4087d97afe"
  end

  depends_on "cmake" => :build
  depends_on "cython" => :build
  depends_on "pkg-config" => :build
  depends_on "blast"
  depends_on "brewsci/bio/rmblast"
  depends_on "brewsci/bio/trf"
  depends_on "hdf5"
  depends_on "hmmer"
  depends_on "numpy"
  depends_on "python@3.12"

  on_linux do
    depends_on "cpanminus" => :build
    depends_on "perl"
  end

  resource "h5py" do
    url "https://files.pythonhosted.org/packages/52/8f/e557819155a282da36fb21f8de4730cfd10a964b52b3ae8d20157ac1c668/h5py-3.11.0.tar.gz"
    sha256 "7b7e8f78072a2edec87c9836f25f34203fd492a4475709a18b417a33cfb21fa9"
  end

  def python3
    "python3.12"
  end

  def install
    # Get Python location
    xy = Language::Python.major_minor_version python3
    # Install Python dependencies
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resource("h5py")
    (lib/"python#{xy}/site-packages/homebrew-repeatmasker.pth").write "#{libexec/"lib/python#{xy}/site-packages"}\n"
    ENV.prepend_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"

    libexec.install Dir["*"]
    if OS.mac?
      perl = "/usr/bin/perl"
      bin.install_symlink "../libexec/RepeatMasker"
    else
      perl = Formula["perl"].bin/"perl"
      ENV["PERL5LIB"] = libexec/"lib/perl5"
      system "cpanm", "--self-contained", "-l", libexec, "Text::Soundex"
      (bin/"RepeatMasker").write_env_script(libexec/"RepeatMasker", PERL5LIB:   ENV["PERL5LIB"],
                                                                    PYTHONPATH: ENV["PYTHONPATH"])
    end

    args = %W[-perlbin #{perl} -trf_prgm #{Formula["trf"].bin/"trf"} -rmblast_dir #{Formula["rmblast"].bin}
              -hmmer_dir #{Formula["hmmer"].bin}]
    cd libexec do
      # Abort configure script if we need to be prompted for an option
      inreplace "configure", "<STDIN>", "2"
      system "./configure", *args
    end
  end

  def caveats
    <<~EOS
      RepeatMasker was installed with a minimal repeat library. To download
      the complete libraries, follow the instructions here:
        #{libexec}/INSTALL
      The default aligner is RMBlast. Change this by running:
        cd #{libexec} && ./configure
    EOS
  end

  test do
    (testpath/"test.fa").write <<~EOFASTA
      >Alu
      GCCGGGCGCGGTGGCGCGTGCCTGTAGTCCCAGCTACTCGGGAGGCTGAGG
      CTGGAGGATCGCTTGAGTCCAGGAGTTCTGGGCTGTAGTGCGCTATGCCGA
      TCGGAATAGCCACTGCACTCCAGCCTGGGCAACATAGCGAGACCCCGTCTC
    EOFASTA

    system bin/"RepeatMasker", "test.fa"
    assert_match "NNNNNNNNNNNNNNNNNNNN", (testpath/"test.fa.masked").read
  end
end
