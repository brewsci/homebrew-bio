class MpEst < Formula
  # cite Liu_2010: "https://doi.org/10.1186/1471-2148-10-302"
  desc "Maximum pseudo-likelihood estimates of species trees"
  homepage "https://faculty.franklin.uga.edu/lliu/content/mp-est"
  url "https://faculty.franklin.uga.edu/lliu/sites/faculty.franklin.uga.edu.lliu/files/mpest_2.0.zip"
  sha256 "56afa1640d7e11f3e2750bb3671f01472c5581088428e00f1f2f1494a84fd057"

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
