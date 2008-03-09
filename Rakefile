require 'rake'

RELEASE_VERSION = '0.0.2'

SRC = 'src'
BIN = 'bin'
TEST = 'test'
LIB = File.join(TEST, 'lib')
WEBSITE = 'website'
COMPILER = 'mxmlc'
RUNNER_NAME = 'sa_flashplayer_9_debug.exe'
RUNNER = File.join('.', RUNNER_NAME)

def compile(name)
  source = File.join(SRC, name + '.mxml');
  target = File.join(BIN, name + '.swf');
  option = "-use-network=false"
  run_compile source, target, option
end

def check_flash_runner
  runner_url = "http://download.macromedia.com/pub/flashplayer/updaters/9/#{RUNNER_NAME}"
  execute "wget #{runner_url}" unless File.exist? RUNNER
  chmod 0755, RUNNER
end

def run_flash(name)
  check_flash_runner
  target = File.join(BIN, name + '.swf')
  run_cmd RUNNER, target
end

task :default => [:clean, :compile_tester, :compile_aut, :prepare_test]

task :release => [:default] do
  web_dist = File.join(WEBSITE, 'public', 'tester')
  rm_rf web_dist
  cp_r BIN, web_dist
  
  zip_file = "Fluorida-#{RELEASE_VERSION}.zip"
  rm_f zip_file
  cd BIN do
    execute "zip -r #{File.join("..", zip_file)} #{Dir["*"].join(" ")}"
  end
end

require 'net/sftp'
task :upload_website do
  Net::SFTP.start('fluorida.thoughtworkers.org', 'fluorida') do |sftp|
    remote_base = "/home/fluorida/fluorida.thoughtworkers.org"
    
    cd WEBSITE do
      Dir["**/*"].each do |local_path|
        puts local_path
        remote_path = "#{remote_base}/#{local_path}"
        if File.directory?(local_path)
          sftp.mkdir remote_path, {:permission => 0777} rescue nil
        else
          sftp.put_file local_path, remote_path
        end
      end
    end
  end  
end

task :server do 
  cd WEBSITE do
    execute "script/server"
  end
end

task :run => [:compile_tester, :compile_aut, :prepare_test] do
  run_flash "Tester"
end

task :compile_tester do
  compile "Tester"
end

task :compile_aut do
  compile 'aut'
  compile 'aut_dragndrop'
end

task :clean do
  rm_rf BIN
end

task :test => [:clean, :compile_unit_test, :prepare_test, :run_unit_test]

task :compile_unit_test do
  source = File.join(TEST, 'unit_test.mxml')
  target = File.join(BIN, 'unit_test.swf')
  unit_test_lib = File.join(LIB, 'flexunit.swc')
  run_compile source, target, '-compiler.source-path+=src', "-compiler.library-path+=#{unit_test_lib}", '-use-network=false'
end

task :prepare_test do
  source_smaple_dir = File.join(TEST, 'sample', '*')
  target_sample_dir = File.join(BIN, 'sample')
  mkdir_p target_sample_dir
  cp Dir[source_smaple_dir], target_sample_dir
  
  source_default_fls = File.join(SRC, 'default.fls')
  source_defult_html = File.join(SRC, 'default.html')
  cp source_default_fls, BIN
  cp source_defult_html, BIN
end

task :run_unit_test do
  run_flash "unit_test"
end

def run_compile(source, target, *options)
    run_cmd COMPILER, source, options.join(' '), "-output #{target}"
end

def run_cmd cmd, *args
    args.unshift cmd
    cmd_text = args.join(' ')
    execute cmd_text
end

def execute(cmd)
  puts cmd
  successful = system cmd
  raise "execution failed!" unless successful
end