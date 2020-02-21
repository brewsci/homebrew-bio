class Freebayes < Formula
  # cite Garrison_2012: "https://arxiv.org/abs/1207.3907v2"
  desc "Bayesian variant discovery and genotyping"
  homepage "https://github.com/ekg/freebayes"
  url "https://github.com/ekg/freebayes.git",
      :tag      => "v1.3.2",
      :revision => "54bf40915ae7e46798503471ac57f593efdb5493"
  head "https://github.com/ekg/freebayes.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "04d29c063def9219df5ae557876fdd4095cfde34e540e2a28acd1109a79f34bf" => :catalina
    sha256 "07f3e4dd360c93efb848b5e4a420a0b32f8ce85d85f21652975aa382716657a9" => :x86_64_linux
  end

  depends_on "cmake" => :build

  depends_on "parallel"
  depends_on "python"
  depends_on "vcflib"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

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
