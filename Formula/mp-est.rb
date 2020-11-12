class MpEst < Formula
  # cite Liu_2010: "https://doi.org/10.1186/1471-2148-10-302"
  desc "Maximum pseudo-likelihood estimates of species trees"
  homepage "https://faculty.franklin.uga.edu/lliu/content/mp-est"
  url "https://faculty.franklin.uga.edu/lliu/sites/faculty.franklin.uga.edu.lliu/files/mpest_2.0.zip"
  sha256 "56afa1640d7e11f3e2750bb3671f01472c5581088428e00f1f2f1494a84fd057"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "a72cbae1d1148f1e6db9c463e438d37d6116297dc8fde033085a9b3c7e9ee436" => :sierra
    sha256 "5e67ffb40cbba00ba401c10cfa30196763e2b049f99d774a35ce3b82fca97982" => :x86_64_linux
  end

  def install
    args = "ARCHITECTURE=unix" if OS.linux?
    cd "src" do
      # Use proper variable for linking libraries with implicit rules
      inreplace "makefile", "LIBS", "LDLIBS"
      system "make", *args
      bin.install "mpest"
    end
    pkgshare.install ["example", "document"]
  end

  test do
    Dir["#{pkgshare}/example/{control,testgenetree}"].each { |f| cp f, testpath }
    system "#{bin}/mpest", "control"
  end
end
