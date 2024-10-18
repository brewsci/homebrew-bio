class Centrifuge < Formula
  # cite Kim_2016: "https://doi.org/10.1101/gr.210641.116"
  desc "Rapid sensitive classification of metagenomic sequences"
  homepage "https://www.ccb.jhu.edu/software/centrifuge"
  url "https://github.com/DaehwanKimLab/centrifuge/archive/refs/tags/v1.0.4.1.tar.gz"
  sha256 "638cc6701688bfdf81173d65fa95332139e11b215b2d25c030f8ae873c34e5cc"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    depends_on "libomp"
  end

  def install
    # VERSION info is not required for the build
    rm "VERSION"
    if OS.mac? && Hardware::CPU.arm?
      # POPCNT_CAPABILITY is not supported on ARM
      inreplace "Makefile", "POPCNT_CAPABILITY ?= 1", "POPCNT_CAPABILITY ?= 0"
      # tweaks for processor_support.h
      inreplace "processor_support.h" do |s|
        s.gsub! "#elif defined(__GNUC__)", "#elif defined(__GNUC__) && (defined(__amd64__) || defined(__i386__))"
        s.gsub! 'std::cerr << "ERROR: please define __cpuid() for this build.\n"; ', ""
        s.gsub! "assert(0);", "return false;"
      end
    end
    system "make"
    bin.install "centrifuge", Dir["centrifuge-*"]
    pkgshare.install "example", "indices", "evaluation"
    doc.install "doc", "MANUAL", "TUTORIAL"
  end

  def caveats
    <<~EOS
      The Makefile for building indices was installed to:
        #{pkgshare}/indices
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/centrifuge --version 2>&1")
  end
end
