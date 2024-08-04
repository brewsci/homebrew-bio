class Ntedit < Formula
  # cite Warren_2019: "https://doi.org/10.1093/bioinformatics/btz400"
  desc "Scalable genome assembly polishing"
  homepage "https://github.com/bcgsc/ntEdit"
  url "https://github.com/bcgsc/ntEdit.git",
      tag:      "v2.0.2",
      revision: "9496cd4d9dd36bd0ea602c02f4a5f64858caa6ba"
  license "GPL-3.0-or-later"
  head "https://github.com/bcgsc/ntEdit.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 catalina:     "299b5fb39c237e03266945ad75736673417553b044f26d69ead428c75fff9681"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8c7e9babe2457e46d6729e70babf7a182bffd4ea743d5a305d3ef837faf1fc58"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "boost"
  depends_on "brewsci/bio/btllib"
  depends_on "brewsci/bio/ntcard"
  depends_on "brewsci/bio/nthits"
  depends_on "python@3.12"
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
