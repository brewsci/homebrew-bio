class Sequencetools < Formula
  desc "Programs for processing sequencing data"
  homepage "https://github.com/stschiff/sequenceTools"
  url "https://github.com/stschiff/sequenceTools.git",
      tag:      "v1.5.4.0",
      revision: "13c46b6ff323c4e04d1cdc49e9b2b0898a6c3e52"
  license "BSD-3-Clause"
  head "https://github.com/stschiff/sequenceTools.git", branch: "master"

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
