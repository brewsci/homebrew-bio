class Cap3 < Formula
  # cite Huang_1999: "https://doi.org/10.1101/gr.9.9.868"
  desc "CAP3: A DNA Sequence Assembly Program"
  homepage "http://seq.cs.iastate.edu/cap3.html"
  if OS.mac?
    url "http://seq.cs.iastate.edu/CAP3/cap3.macosx.intel64.tar"
    sha256 "4b6e8fa6b39147b23ada6add080854ea9fadace9a9c8870a97ac79ff1c75338e"
  else
    url "http://seq.cs.iastate.edu/CAP3/cap3.linux.x86_64.tar"
    sha256 "3aff30423e052887925b32f31bdd76764406661f2be3750afbf46341c3d38a06"
  end
  version "2015-02-11"

  depends_on "patchelf" => :build unless OS.mac?

  def install
    tools = %w[cap3 formcon]
    bin.install *tools
    if OS.linux?
      tools.each do |exe|
        system "patchelf",
          "--set-interpreter", HOMEBREW_PREFIX/"lib/ld.so",
          "--set-rpath", HOMEBREW_PREFIX/"lib",
          bin/exe
      end
    end
    doc.install %w[README aceform doc]
    pkgshare.install "example"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/cap3 2>&1", 1)
  end
end
