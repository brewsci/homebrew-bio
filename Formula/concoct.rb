class Concoct < Formula
  desc "Clustering cONtigs with COverage and ComposiTion"
  homepage "https://github.com/BinPro/CONCOCT"
  url "https://github.com/BinPro/CONCOCT/archive/1.0.0.tar.gz"
  sha256 "4428a1d7bce5c7546106bea0a0ff6c2168e3680f6422adce5ef523bce46dc180"
  head "https://github.com/BinPro/CONCOCT.git"

  depends_on "cython"
  depends_on "gcc" if OS.mac?
  depends_on "gsl"
  depends_on "numpy"
  depends_on "scipy"

  fails_with :clang # Requires OpenMP

  resource "argparse" do
    url "https://files.pythonhosted.org/packages/18/dd/e617cfc3f6210ae183374cd9f6a26b20514bbb5a792af97949c5aacddf0f/argparse-1.4.0.tar.gz"
    sha256 "62b089a55be1d8949cd2bc7e0df0bddb9e028faefc8c32038cc84862aefdd6e4"
  end

  resource "bcbio-gff" do
    url "https://files.pythonhosted.org/packages/ba/93/34156e0ed3eff9dbd52035f53a48b2ff7ae6bd877cda23ea9fce26cac9fc/bcbio-gff-0.6.6.tar.gz"
    sha256 "74c6920c91ca18ed9cb872e9471c0be442dad143d8176345917eb1fefc86bc37"
  end

  resource "biopython" do
    url "https://files.pythonhosted.org/packages/7a/4a/0d4381a60b6e942c6772b01cfb931196f1a9c33910cc43fbd4faccbd7d9f/biopython-1.73.tar.gz"
    sha256 "70c5cc27dc61c23d18bb33b6d38d70edc4b926033aea3b7434737c731c94a5e0"
  end

  resource "nose" do
    url "https://files.pythonhosted.org/packages/58/a5/0dc93c3ec33f4e281849523a5a913fa1eea9a3068acfa754d44d88107a44/nose-1.3.7.tar.gz"
    sha256 "f1bffef9cbc82628f6e7d7b40d7e255aefaa1adb6a1b1d26c69a8b79e6208a98"
  end

  resource "pandas" do
    url "https://files.pythonhosted.org/packages/b2/4c/b6f966ac91c5670ba4ef0b0b5613b5379e3c7abdfad4e7b89a87d73bae13/pandas-0.24.2.tar.gz"
    sha256 "4f919f409c433577a501e023943e582c57355d50a724c589e78bc1d551a535a2"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/ad/99/5b2e99737edeb28c71bcbec5b5dda19d0d9ef3ca3e92e3e925e7c0bb364c/python-dateutil-2.8.0.tar.gz"
    sha256 "c89805f6f4d64db21ed966fda138f8a5ed7a4fdbc1a8ee329ce1b74e3c74da9e"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/df/d5/3e3ff673e8f3096921b3f1b79ce04b832e0100b4741573154b72b756a681/pytz-2019.1.tar.gz"
    sha256 "d747dd3d23d77ef44c6a3526e274af6efeb0a6f1afd5a69ba4d5be4098c8e141"
  end

  resource "scikit-learn" do
    url "https://files.pythonhosted.org/packages/f1/cb/3297656b9a3cce0cb60c691d568225fc025d47d3eb668b3c480211801a52/scikit-learn-0.20.3.tar.gz"
    sha256 "c503802a81de18b8b4d40d069f5e363795ee44b1605f38bc104160ca3bfe2c41"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"

    resources.each do |r|
      r.stage do
        system "python3", *Language::Python.setup_install_args(libexec)
      end
    end

    system "python3", *Language::Python.setup_install_args(libexec)

    (bin/"concoct").write_env_script libexec/"bin/concoct", :PYTHONPATH => ENV["PYTHONPATH"]
    (bin/"concoct_refine").write_env_script libexec/"bin/concoct_refine", :PYTHONPATH => ENV["PYTHONPATH"]
    (bin/"concoct_coverage_table.py").write_env_script libexec/"bin/concoct_coverage_table.py", :PYTHONPATH => ENV["PYTHONPATH"]
    (bin/"concoct_cut_up_fasta.py").write_env_script libexec/"bin/cut_up_fasta.py", :PYTHONPATH => ENV["PYTHONPATH"]
    (bin/"concoct_merge_cutup_clustering.py").write_env_script libexec/"bin/merge_cutup_clustering.py", :PYTHONPATH => ENV["PYTHONPATH"]
    (bin/"concoct_extract_fasta_bins.py").write_env_script libexec/"bin/extract_fasta_bins.py", :PYTHONPATH => ENV["PYTHONPATH"]
  end

  def caveats; <<~EOS
    Helper tools are been prefixed with 'concoct_':
        cut_up_fasta.py => concoct_cut_up_fasta.py
        merge_cutup_clustering.py => concoct_merge_cutup_clustering.py
        extract_fasta_bins.py => concoct_extract_fasta_bins.py
  EOS
  end

  test do
    assert_match "usage", shell_output("#{bin}/concoct -h")
  end
end
