# Documentation: https://docs.brew.sh/Formula-Cookbook.html
#                http://www.rubydoc.info/github/Homebrew/brew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Eclim < Formula
  desc "Expose eclipse features inside of vim."
  homepage "http://eclim.org"
  url "https://github.com/ervandew/eclim/releases/download/2.7.0/eclim_2.7.0.jar",
      :using => :nounzip
  sha256 "95cdf8608fd4f11602adde8f04e51a986af99722f1e9a34b1ee18669bbb3903e"

  head "git://github.com/ervandew/eclim.git" do
    depends_on "ant"
  end

  depends_on :java => :build

  def install
    eclipse_location = "/Applications/Eclipse Java.app/Contents/Eclipse" ||
                       ENV["ECLIPSE_HOME"]
    vim_home = "#{Dir.home(ENV["USER"])}/.vim" || ENV["VIM_HOME"]
    # eclim requires the Eclipse home and vim directories to build
    if !Dir.exist?(eclipse_location)
      odie "Could not find Eclipse installed. Ensure Eclipse is " \
        "installed in #{eclipse_location} or the location is set in the " \
        "ECLIPSE_HOME variable."
    elsif !Dir.exist?(vim_home)
      odie "Could not locate vim files. Ensure vim config files are in " \
        "#{vim_home} or the location is set in the VIM_HOME variable."
    end

    if build.head?
      system "ant", "-Declipse.home=#{eclipse_location}"
    else
      system "java",
             "-Declipse.home=#{eclipse_location}",
             "-Dvim.files=#{vim_home}",
             "-jar", "eclim_#{version}.jar",
             "install"
    end
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test eclim`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
