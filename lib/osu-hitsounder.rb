module OsuHitsounder
  class Manage

    #[TimingPoints]
    #Syntax: Offset, Milliseconds per Beat, Meter, Sample Set, Sample Index, Volume, Inherited, Kiai Mode
    #[HitObjects]
    #Syntax: x,y,time,type,hitSound...,extras
    def self.read_copier(namefile)
      copier_hash = {}
      buff_hit_objects = ""
      buff_timing_points = ""
      buff_bookmarks = ""
      File.open(namefile, "r") do |f|
        f.each_line do |line|
          buff_bookmarks << line if line.include? "Bookmarks:"
          if line.include? "[TimingPoints]"
            while(line = f.gets) != nil
              buff_timing_points << line
              break if line.include?("")
            end
          end
          if line.include? "[HitObjects]"
            while(line = f.gets) != nil
              buff_hit_objects << line
              break if line.include?("")
            end
          end
        end
      end
      copier_hash[:hit_objects] = buff_hit_objects
      copier_hash[:timing_points] = buff_timing_points
      copier_hash[:bookmarks] = buff_bookmarks

      copier_hash
    end

    def self.copy_hitsound(name_files)
      copier = read_copier(name_files[:hitsound_copier])
      puts copier

    end
  end
end