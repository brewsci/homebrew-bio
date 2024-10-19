class Ntedit < Formula
  # cite Warren_2019: "https://doi.org/10.1093/bioinformatics/btz400"
  desc "Scalable genome assembly polishing"
  homepage "https://github.com/bcgsc/ntEdit"
  url "https://github.com/bcgsc/ntEdit.git",
      tag:      "v2.0.3",
      revision: "d004dbc6166f044d7d576dac3f8f7c81c180e008"
  license "GPL-3.0-or-later"
  head "https://github.com/bcgsc/ntEdit.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sonoma: "cf201c8f86565a89d5a5b732ed049c482d9e275492a7d60d1bbe8ef0c25ccc40"
    sha256 cellar: :any,                 ventura:      "54cd9d824f98847b6398df3998fa88f4ed4c65edace82bd58c25bf1d2c794b7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d5f9b84d888fd3df1caad6cd3921d3ed05ce0cfcead3a0578d23b773d06aed39"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on xcode: :build
  depends_on "boost"
  depends_on "brewsci/bio/btllib"
  depends_on "brewsci/bio/ntcard"
  depends_on "brewsci/bio/nthits"
  depends_on "python@3.13"
  depends_on "snakemake"

  uses_from_macos "perl"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  def install
    inreplace "run-ntedit", "#!/usr/bin/env python3",
                            "#!#{Formula["snakemake"].opt_libexec}/bin/python3.12"
    system "meson", "setup", "build", "--prefix", prefix
    cd "build" do
      system "ninja", "install"
    end
    pkgshare.install "demo"
  end

  test do
    # Use official test demo, but decompression is necessary before run-ntedit
    resource "test_data1" do
      url "https://www.bcgsc.ca/downloads/btl/ntedit/sim_reads_ecoli/Sim_100_300_1.fq.gz"
      sha256 "51d1bb263f1803b387d6189148024ed56e7499b3ee323016f167bc89638f62dc"
    end

    resource "test_data2" do
      url "https://www.bcgsc.ca/downloads/btl/ntedit/sim_reads_ecoli/Sim_100_300_2.fq.gz"
      sha256 "322de7d18e4a4bbb138dff1e404bb0a9862983e37a77211c97682ea5b754466f"
    end

    resources.each do |r|
      r.stage(testpath)
    end
    cp pkgshare/"demo/ecoliWithMismatches001Indels0001.fa.gz", testpath
    cp pkgshare/"demo/ecoli_ntedit_k25_edited.fa", testpath
    cp pkgshare/"demo/ecoli_ntedit_k25_changes.tsv", testpath
    system bin/"run-ntedit", "polish", "-k", "25", "-d", "5", "-i", "4",
                         "--reads", "Sim_100_300", "--draft", "ecoliWithMismatches001Indels0001.fa.gz"
    system "diff", "-q", "ntedit_k25_edited.fa", "ecoli_ntedit_k25_edited.fa"
    system "diff", "-q", "ntedit_k25_changes.tsv", "ecoli_ntedit_k25_changes.tsv"
  end
end
