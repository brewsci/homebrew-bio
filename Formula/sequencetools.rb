class Sequencetools < Formula
  desc "Programs for processing sequencing data"
  homepage "https://github.com/stschiff/sequenceTools"
  url "https://github.com/stschiff/sequenceTools.git",
      tag:      "v1.5.4.0",
      revision: "13c46b6ff323c4e04d1cdc49e9b2b0898a6c3e52"
  license "BSD-3-Clause"
  head "https://github.com/stschiff/sequenceTools.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b29983ab3c81cd2f90e3add58cd1b5fa31ab5b99a97bca2ac201d09b5880573"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d321b100b8c43dff965b78e360d36b66290732eb7b3ce535acbe42e4d4117acc"
    sha256 cellar: :any_skip_relocation, ventura:       "82fd3d8019a9e0a44cc21f869d1a572db6ba51e5240495c749ba6394e03a47d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24985a0092e2455354d6dbd94791a12604580862178c175fb43079cf48dfab08"
  end

  depends_on "ghc@9.6" => :build
  depends_on "haskell-stack" => :build

  def install
    stack_args = %W[
      -v
      --system-ghc
      --no-install-ghc
      --skip-ghc-check
      --ghc-options="-O2"
      --copy-bins
      --local-bin-path=#{bin}
    ]

    system "stack", "build", *stack_args

    prefix.install "test"
    pkgshare.install "scripts"
  end

  test do
    cp Dir[prefix/"test/testDat/*.txt"], testpath
    pileup_output = shell_output("#{bin}/pileupCaller --sampleNames 12880A,12881A,12883A,12885A " \
                                 "--randomHaploid --singleStrandMode -f 1240k_eigenstrat_snp_short.snp.txt " \
                                 "< AncientBritish.short.pileup.txt 2>&1 1> /dev/null")
    assert_match(/^SampleName\s+TotalSites\s+/, pileup_output)
    assert_match(/^12880A\s+2400\s+1251\s+/, pileup_output)
    assert_match(/^12881A\s+2400\s+2000\s+/, pileup_output)
    assert_match(/^12883A\s+2400\s+1969\s+/, pileup_output)
    assert_match(/^12885A\s+2400\s+1029\s+/, pileup_output)
  end
end
