class BwaMem2 < Formula
  desc "Next version of bwa-mem short read aligner"
  homepage "https://github.com/bwa-mem2/bwa-mem2"
  url "https://github.com/bwa-mem2/bwa-mem2.git",
      tag:      "v2.0",
      revision: "cbcc183c0843d20d45c84e066177eb8d58be2f9b"
  head "https://github.com/bwa-mem2/bwa-mem2.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "ccaf67262f2f7e7f711d6f482ad004161c66aef0c55cadcb7ec4907a228f074d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "943583113491f963bd0e8460994ec17a95f19208a62b07a8d514d18e648ddf7d"
  end

  uses_from_macos "zlib"

  def install
    # Fix the error: error: conflicting types for 'memset_s'
    # See https://github.com/intel/safestringlib/issues/14
    inreplace "ext/safestringlib/include/safe_mem_lib.h",
      "extern errno_t memset_s",
      "//xxx extern errno_t memset_s"

    system "make"
    bin.install "bwa-mem2"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bwa-mem2 version 2>&1")
  end
end
