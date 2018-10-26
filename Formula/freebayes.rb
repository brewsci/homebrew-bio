class Freebayes < Formula
  # cite Garrison_2012: "https://arxiv.org/abs/1207.3907v2"
  desc "Bayesian variant discovery and genotyping"
  homepage "https://github.com/ekg/freebayes"
  url "https://github.com/ekg/freebayes.git",
      :tag => "v1.2.0",
      :revision => "40155b407a4bead708aaafcadf7904854c411275"
  head "https://github.com/ekg/freebayes.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "c31f2510892d984b82447c64293f0937bd85bc5a7cbd671d200a0663f5ba5722" => :sierra
    sha256 "ec3a1bda228061b3388111425e32765196669f44f3cdbc8e0408f5770de7787d" => :x86_64_linux
  end

  depends_on "cmake" => :build

  depends_on "parallel"
  depends_on "vcflib"
  depends_on "xz"

  unless OS.mac?
    depends_on "bzip2"
    depends_on "zlib"
  end

  def install
    # make -j N results in: make: *** [all] Error 2
    # Reported 16 Jan 2017 https://github.com/ekg/freebayes/issues/356
    ENV.deparallelize

    # Works around ld: internal error: atom not found in symbolIndex
    # Reported 21 Jul 2014 https://github.com/ekg/freebayes/issues/83
    inreplace "vcflib/smithwaterman/Makefile", "-Wl,-s", "" if OS.mac?

    # Fixes bug ../vcflib/scripts/vcffirstheader: file not found
    # Reported 1 Apr 2017 https://github.com/ekg/freebayes/issues/376
    inreplace "scripts/freebayes-parallel" do |s|
      s.gsub! "../vcflib/scripts/vcffirstheader", "vcffirstheader"
      s.gsub! "../vcflib/bin/vcfstreamsort", "vcfstreamsort"
    end

    system "make"

    bin.install "bin/freebayes"
    bin.install "bin/bamleftalign"
    bin.install "scripts/freebayes-parallel"
    bin.install "scripts/coverage_to_regions.py"
    bin.install "scripts/generate_freebayes_region_scripts.sh"
    bin.install "scripts/fasta_generate_regions.py"
  end

  test do
    assert_match "polymorphism", shell_output("#{bin}/freebayes --help 2>&1")
    assert_match "chunks", shell_output("#{bin}/freebayes-parallel 2>&1")
  end
end
