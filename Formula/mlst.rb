class Mlst < Formula
  desc "Multi-Locus Sequence Typing of bacterial contigs"
  homepage "https://github.com/tseemann/mlst"
  url "https://github.com/tseemann/mlst/archive/v2.17.6.tar.gz"
  sha256 "223c6b4751bc4fb7fe9d41f56e75c90235b1eba022f987abc1d75ae51fc50819"
  head "https://github.com/tseemann/mlst.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "c1825f9550326f6ee5aaeebca222fa25ae992ba11ecb5674ae4339721f91dbc9" => :sierra
    sha256 "86c5be147f02d9eab21a032d53266bcfa6bff6af0d893d6955bff8f1aa98f1a7" => :x86_64_linux
  end

  depends_on "cpanminus" => :build
  depends_on "pkg-config" => :build

  depends_on "any2fasta"
  depends_on "blast"
  depends_on "perl" # needs 5.26 so can't use Mac perl
  depends_on "wget"
  depends_on "zlib" unless OS.mac?

  def install
    libexec.install Dir["*"]
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    system "cpanm", "--self-contained", "-l", libexec, "Moo", "List::MoreUtils", "JSON"
    (bin/"mlst").write_env_script("#{libexec}/bin/mlst", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    tdir = libexec/"test"
    assert_match version.to_s, shell_output("#{bin}/mlst --version")
    assert_match "senterica", shell_output("#{bin}/mlst --list 2>&1")
    system "#{bin}/mlst", "--check"
    system "#{bin}/mlst -q #{tdir}/example.fna.gz | grep -w 184"
    system "#{bin}/mlst -q #{tdir}/example.gbk.gz | grep -w 184"
    system "gzip -d -c #{tdir}/example.fna.gz | #{bin}/mlst -q /dev/stdin | grep -w 184"
    system "gzip -d -c #{tdir}/example.gbk.gz | #{bin}/mlst -q /dev/stdin | grep -w 184"
    system "#{bin}/mlst -q --csv #{tdir}/example.fna.gz | grep ',184,'"
  end
end
