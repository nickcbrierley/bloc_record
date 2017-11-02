require 'sqlite3'

module Selection
    def find(*ids)
        valid_input = false
        ids.each do |x|
            if x.is_a?(String) == false || x > 0
                valid_input == true
            end
        end
        
        if ids.length == 1 && valid_input
            find_one(ids.first)
        elsif valid_input
            rows = connection.execute <<-SQL
                SELECT #{columns.join ","} FROM #{table}
                WHERE id IN (#{ids.join(",")});
            SQL
            
            rows_to_array(rows)
        else
            puts "Please provide a valid input"
        end
    end
    
    def find_one(id)
        if id.is_a?(String) == false && x > 0
            row = connection.get_first_row <<-SQL
                SELECT #{columns.join ","} FROM #{table}
                WHERE id = #{id};
            SQL
        end
        
        init_object_from_row(row)
    end
    
    def find_by(attribute, value)
        row = connection.get_first_row <<-SQL
            SELECT #{columns.join ","} FROM #{table}
            WHERE #{attribute} = #{BlocRecord::Utility.sql_strings(value)};
        SQL
        
        init_object_from_row(row)
    end
    
    def take(num=1)
        if num > 1
            rows = connection.execute <<-SQL
                SELECT #{columns.join ","} FROM #{table}
                ORDER BY random()
                LIMIT #{num};
            SQL
            
            rows_to_array(rows)
        else
            take_one
        end
    end

    def first
        row = connection.get_first_row <<-SQL
            SELECT #{columns.join ","} FROM #{table}
            ORDER BY id ASC LIMIT 1;
        SQL
        
        init_object_from_row(row)
    end
        
    def last
        row = connection.get_first_row <<-SQL
            SELECT #{columns.join ","} FROM #{table}
            ORDER BY id DESC LIMIT 1;
        SQL
        
        init_object_from_row(row)
    end
    
    def take_one
        row = connection.get_first_row <<-SQL
            SELECT #{columns.join ","} FROM #{table}
            ORDER BY random()
            LIMIT 1;
        SQL
        
        init_object_from_row(row)
    end
    
    def all
        rows = connection.execute <<-SQL
            SELECT #{columns.join ","} FROM #{table};
        SQL
        
        rows_to_array(rows)
    end
        
    def self.method_missing(m, *arg, &block)
        if m.to_s =~ /^find_by_(.*)$/
            find_by($1.to_sym, arg.first)
        else
            super
        end
    end
    
    def find_each(hash)
        rows = connection.execute <<-SQL
            SELECT #{columns.join(",")} FROM #{table}
            WHERE id = #{hash[:start]} LIMIT #{hash[:batch_size]}
        SQL
        current_row_index = 0
        while current_row_index <= rows.length - 1
            yield rows[current_row_index]
            current_row_index += 1
        end
    end
        
    def find_in_batches(hash)
        rows = connection.execute <<-SQL
            SELECT #{columns.join(",")} FROM #{table}
            WHERE id = #{hash[:start]} LIMIT #{hash[:batch_size]}
        SQL
        yield rows
    end
    
    private
    def init_object_from_row(row)
        if row 
            data = Hash[columns.zip(row)]
            new(data)
        end
    end
    
    def rows_to_array(rows)
        rows.map { |row| new(Hash[columns.zip(row)]) }
    end
end