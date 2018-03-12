class Trnascan < Formula
  # cite "https://doi.org/10.1093/nar/25.5.0955"
  desc "Detect tRNA in genome sequence"
  homepage "http://eddylab.org/software.html"
  url "http://eddylab.org/software/tRNAscan-SE/tRNAscan-SE.tar.Z"
  version "1.23"
  sha256 "843caf3e258a6293300513ddca7eb7dbbd2225e5baae1e5a7bcafd509f6dd550"

  def install
    system "make", "all", "CFLAGS=-D_POSIX_C_SOURCE=1", "BINDIR=#{bin}", "LIBDIR=#{libexec}"
    bin.install %w[coves-SE covels-SE eufindtRNA trnascan-1.4 tRNAscan-SE]
    libexec.install Dir["gcode.*", "*.cm", "*signal"]
    man1.install "tRNAscan-SE.man" => "tRNAscan-SE.1"
    prefix.install "Demo"
    (prefix/"Demo").install "testrun.ref"
  end

  test do
    system "#{bin}/tRNAscan-SE", "-d", "-y", "-o", "test.out", "#{prefix}/Demo/F22B7.fa"
    assert_predicate testpath/"test.out", :exist?
    assert_equal File.read("test.out"), File.read(prefix/"Demo/testrun.ref")
  end
end
