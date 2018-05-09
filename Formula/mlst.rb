class Mlst < Formula
  desc "Multi-Locus Sequence Typing of microbial contigs"
  homepage "https://github.com/tseemann/mlst"
  url "https://github.com/tseemann/mlst/archive/v2.10.tar.gz"
  sha256 "431c50a8b5f48f0261049902dd22a6eec3a02579bd8590713f5b31a4db6ce1ed"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "2e6e46dcd6d2ce9ddb1ae240a4c997239b691bf54c335c6146eb82f620293c37" => :sierra_or_later
    sha256 "e98041a7dfb48fb55227f04d6ddd08e3914420b537126fcf7837748e038ba3d8" => :x86_64_linux
  end

  depends_on "cpanminus" => :build
  depends_on "pkg-config" => :build

  depends_on "blast"
  unless OS.mac?
    depends_on "gzip"
    depends_on "perl"
  end

  def install
    libexec.install Dir["*"]
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    system "cpanm", "--self-contained", "-l", libexec,
      "Moo", "List::MoreUtils", "JSON", "File::Slurp"
    (bin/"mlst").write_env_script("#{libexec}/bin/mlst", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    tdir = libexec/"test"
    assert_match version.to_s, shell_output("#{bin}/mlst --version")
    assert_match "senterica", shell_output("#{bin}/mlst --list 2>&1")
    system "#{bin}/mlst -q #{tdir}/example.fna.gz | grep -w 184"
    system "#{bin}/mlst -q #{tdir}/example.gbk.gz | grep -w 184"
    system "gzip -d -c #{tdir}/example.fna.gz | #{bin}/mlst -q /dev/stdin | grep -w 184"
    system "gzip -d -c #{tdir}/example.gbk.gz | #{bin}/mlst -q /dev/stdin | grep -w 184"
    system "#{bin}/mlst -q --csv #{tdir}/example.fna.gz | grep ',184,'"
  end
end
