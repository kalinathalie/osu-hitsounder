module OsuHitsounder
  class Manage
    #improved function for underscore names, ex: HitObjects to hit_objects
    def self.underscore(tag)
      tag.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase
    end

    #improved function for camelize names, ex: hit_objects to HitObjects
    def self.camelize(tag)
      tag.split('_').collect(&:capitalize).join
    end
    
    #Read Osu file and return a Hash with every element
    def self.read_file(namefile)
      file_hash = {}
      buff_version = ""
      buff_general = ""
      buff_editor = ""
      buff_metadata = ""
      buff_difficulty = ""
      buff_events = ""
      buff_timing_points = ""
      buff_colours = ""
      buff_hit_objects = ""

      tag_list = %w"version general editor metadata difficulty events timing_points colours hit_objects"
      File.open(namefile, "r") do |f|
        buff_version << f.readline[0...-1]
        f.each_line do |line|
          next if line.length < 2
          if tag_list.include? underscore(line[1...-2])
            host = "buff_#{underscore(line[1...-2])}"
            while(line = f.gets) != nil
              eval("#{host} << line[0...-1]+'$'")
              break if line.eql?("\n")
            end
          end
        end
      end
      file_hash[:version] = buff_version
      file_hash[:general] = buff_general
      file_hash[:editor] = buff_editor
      file_hash[:metadata] = buff_metadata
      file_hash[:difficulty] = buff_difficulty
      file_hash[:events] = buff_events
      file_hash[:timing_points] = buff_timing_points
      file_hash[:colours] = buff_colours
      file_hash[:hit_objects] = buff_hit_objects

      file_hash
    end

    def self.merge_timing_points(copier_points, pas_points)
      f.write("[#{camelize(k.to_s)}]\n")
        v.split("$").each do |each_v|
          f.write("#{each_v}\n")
        end
        f.write("\n")
    end

    #Write Hitsound Info on paster file from copier
    def self.write_paster(copier_hash, paster_hash, namefile)
      #mudar esse saidinha depois pra namefile
      File.open("saidinha.txt", "w") do |f|
        paster_hash.each do |k, v|
          case k
          when :version
            f.write("#{v}\n\n")
          when :timing_points
            merge_timing_points(v, copier_hash[:timing_points])
          else
            f.write("[#{camelize(k.to_s)}]\n")
            v.split("$").each do |each_v|
              f.write("#{each_v}\n")
            end
            f.write("\n")
          end
        end
      end
    end

    #Mainly function for copy hitsound, read an write osu files
    def self.copy_hitsound(name_files)
      copier_hash = read_file(name_files[:hitsound_copier])
      paster_hash = read_file(name_files[:hitsound_paster])

      write_paster(copier_hash, paster_hash, name_files[:hitsound_paster])


    end
  end
end