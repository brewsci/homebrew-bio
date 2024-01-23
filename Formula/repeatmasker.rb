class Repeatmasker < Formula
  desc "Program that screens DNA sequences for interspersed repeats"
  homepage "http://www.repeatmasker.org/"
  url "http://repeatmasker.org/RepeatMasker/RepeatMasker-4.1.3.tar.gz"
  sha256 "39cbd86af851df9343b2af92f5f286537efa6f3f915957ee446fb0054d220a01"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any_skip_relocation, x86_64_linux: "366fc75de9aa4f245d4386ec226d39c27136e827712d8b8b75d3ae4087d97afe"
  end

  depends_on "pkg-config" => :build
  depends_on "blast"
  depends_on "brewsci/bio/rmblast"
  depends_on "brewsci/bio/trf"
  depends_on "hdf5"
  depends_on "hmmer"
  depends_on "numpy"
  depends_on "python@3.10"

  on_linux do
    depends_on "cpanminus" => :build
    depends_on "perl"
  end

  resource "cython" do
    url "https://files.pythonhosted.org/packages/4c/76/1e41fbb365ad20b6efab2e61b0f4751518444c953b390f9b2d36cf97eea0/Cython-0.29.32.tar.gz"
    sha256 "8733cf4758b79304f2a4e39ebfac5e92341bce47bcceb26c1254398b2f8c1af7"
  end

  resource "pkgconfig" do
    url "https://files.pythonhosted.org/packages/c4/e0/e05fee8b5425db6f83237128742e7e5ef26219b687ab8f0d41ed0422125e/pkgconfig-1.5.5.tar.gz"
    sha256 "deb4163ef11f75b520d822d9505c1f462761b4309b1bb713d08689759ea8b899"
  end

  resource "h5py" do
    url "https://files.pythonhosted.org/packages/69/f4/3172bb63d3c57e24aec42bb93fcf1da4102752701ab5ad10b3ded00d0c5b/h5py-3.8.0.tar.gz"
    sha256 "6fead82f0c4000cf38d53f9c030780d81bfa0220218aee13b90b7701c937d95f"
  end

  def python3
    "python3.10"
  end

  def install
    site_packages = Language::Python.site_packages(python3)
    ENV.prepend_create_path "PYTHONPATH", libexec/site_packages
    %w[cython pkgconfig h5py].each do |r|
      resource(r).stage { system python3, *Language::Python.setup_install_args(libexec, python3) }
    end

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
      inreplace "RepeatMaskerConfig.pm", "$value = <STDIN>", 'die "set value for $param"'
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
