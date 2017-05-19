require "formula"

class Toever < Formula
  homepage "https://github.com/nissy/toever/"
  url "https://pypi.python.org/packages/source/t/toever/toever-1.9.6.tar.gz"
  sha256 "70af0119d3abe61f273dc41aa7f86c4be6170f75678d3a7e662dc0bab26f16ea"

  resource "evernote" do
    url "https://pypi.python.org/packages/source/e/evernote/evernote-1.25.0.tar.gz"
    sha256 "4d801dde4c300931996f4b93ba4a41ab280048a80a7e598800a38c789d7994d3"
  end

  resource "clint" do
    url "https://pypi.python.org/packages/source/c/clint/clint-0.4.1.tar.gz"
    sha256 "3a9e7ba7ceaa10276bcfe85110a04633813344406ec6181063cd79210b2804a8"
  end

  resource "chardet" do
    url "https://pypi.python.org/packages/source/c/chardet/chardet-2.3.0.tar.gz"
    sha256 "e53e38b3a4afe6d1132de62b7400a4ac363452dc5dfcf8d88e8e0cce663c68aa"
  end

  resource "keyring" do
    url "https://pypi.python.org/packages/source/k/keyring/keyring-4.0.zip"
    sha256 "ea93c3cd9666c648263df4daadc5f34aeb27415dbf8e4d76579a8a737f1741cf"
  end

  def install
    ENV["PYTHONPATH"] = lib+"python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", prefix+"lib/python2.7/site-packages"
    install_args = [ "setup.py", "install", "--prefix=#{libexec}" ]

    res = %w[evernote clint chardet keyring]
    res.each do |r|
      resource(r).stage { system "python", *install_args }
    end

    system "python", "setup.py", "install", "--prefix=#{prefix}"

    rm Dir["#{bin}/easy_install*"]
    rm "#{lib}/python2.7/site-packages/site.py"
    rm Dir["#{lib}/python2.7/site-packages/*.pth"]

    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/tover", "-v"
  end
end
