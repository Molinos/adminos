module Adminos
  module Generators
    class GemfileMerge
      GROUP_NAME_PATTERN = /^group(\D+)do$/
      GEM_NAME_PATTERN = /^gem\s+\'([^\']+)\'/

      def initialize(from, to)
        @from_lines = from.each_line.map { |line| line.chomp.tr('"', "'") }
        @to_lines = to.each_line.map { |line| line.chomp.tr('"', "'") }
      end

      def merge
        current_group = nil
        @from_lines.each do |line|
          current_group = new_current_group(line, current_group)

          if gem?(line)
            merge_gem(line, current_group)
          end
        end

        @to_lines.map do |line|
          line.gsub(/'([^']*\#{[^']+}[^']*)'/, '"\\1"')
        end.join("\n")
      end

      private

      def gem?(line)
        GEM_NAME_PATTERN.match(line.strip)
      end

      def new_current_group(line, current_group)
        if current_group
          line == 'end' ? nil : current_group
        elsif GROUP_NAME_PATTERN.match(line)
          GROUP_NAME_PATTERN.match(line)[1].strip
        else
          nil
        end
      end

      def merge_gem(from_line, group)
        gem_name = GEM_NAME_PATTERN.match(from_line.strip)[1]

        current_group = nil
        # ищем и заменяем гем
        @to_lines.each_with_index do |to_line, index|
          old_group = current_group
          current_group = new_current_group(to_line, current_group)

          if old_group && old_group == group && current_group != group
            @to_lines.insert(index, "#{from_line} # from adminos")
            return
          end

          if current_group == group && gem?(to_line.strip)
            # нужная группа
            current_gem_name = GEM_NAME_PATTERN.match(to_line.strip)[1]
            if current_gem_name == gem_name
              # нужный гем
              if from_line == to_line
                # гемы совпали
                # @to_lines[index] +=" # adminos coincidence"
                return
              else
                @to_lines.insert(index + 1, "# #{from_line} # adminos conflict")
                return
              end
            end
          end
        end

        # добавляем гем
        if group.blank?
          @to_lines.push("#{from_line} # from adminos")
        else
          @to_lines.push("group #{group} do")
          @to_lines.push("#{from_line} # from adminos")
          @to_lines.push("end")
        end
      end
    end
  end
end
