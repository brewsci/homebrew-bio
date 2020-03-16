class Vmatch < Formula
  desc "Large scale sequence analysis software"
  homepage "http://www.vmatch.de/"
  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "510633853d4500dd2cd36b522fdef69056c594c17f14c624613a84300cceeb4d" => :catalina
    sha256 "a543d450bdedad7174a277f0b9060443ef7a43954f731c89a7fbbdd35430c4e6" => :x86_64_linux
  end

  if OS.mac?
    url "http://www.vmatch.de/distributions/vmatch-2.3.1-Darwin_i386-64bit.tar.gz"
    sha256 "0def2a69515cd36a68724b76f60eca904d2445125d956a7974e34cb72904feda"
  elsif OS.linux?
    url "http://www.vmatch.de/distributions/vmatch-2.3.1-Linux_x86_64-64bit.tar.gz"
    sha256 "2b28f1f5f6ca3780d75889c63f2b5c9ac4b63c9807d98035668c9beddbd9241a"
  end

  depends_on "patchelf" => :build unless OS.mac?

  def install
    exes = %w[chain2dim matchcluster mkdna6idx mkvtree vendian vmatch
              vmatchselect vseqinfo vseqselect vstree2tex vsubseqselect]
    bin.install exes
    unless OS.mac?
      exes.each do |exe|
        system "patchelf",
          "--set-interpreter", HOMEBREW_PREFIX/"lib/ld.so",
          "--set-rpath", HOMEBREW_PREFIX/"lib",
          bin/exe
      end
    end
    doc.install Dir["*.pdf"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vmatch -version 2>&1")
  end
end
