require_relative "req.rb"


=begin
    Select col from data
    Select * from data
    Select col from data where
    Select * from data where
    Select col from data where join data on col1 = col2 
    select col from data where condition order by col asc

    update data where condition

    delete data where condition

    insert data where condition
=end


csvr = MySqliteRequest.new
puts "=============================="
puts "***Select col from data***"
puts "=============================="

csvr.from("data.csv").select("weight").run
puts "=============================="
puts "***Select * from data***"
puts "=============================="
csvr.from("nba_player_data.csv").select("*").where("weight",240).run

puts "========================================================================"
puts "SELECT name, year_start FROM data WHERE year_start = 2017"
csvr.from("data.csv").select("name", "year_start").where("year_start", 2017).run


puts "========================================================================"
puts "SELECT * FROM data JOIN data_to_join ON name = player WHERE weight = 240"
csvr.from("data.csv").select("*").join("name","data_to_join.csv","player").where("weight",240).run

puts "========================================================================"
puts "SELECT name FROM data JOIN data_to_join ON name = player"
csvr.from("data.csv").select("name").join("name","data_to_join.csv","player").run

=begin
puts "=============================="
puts "***select col from data where condition order by col asc***"
puts "=============================="
csvr.from("nba_players.csv").select("*").where("weight", "77").order("name","asc").run
=end












        # check if where is set
        # smashing table together if where is not set
=begin
        if (@where_column && @where_criteria)
            # printing out based table only
            csv1.each do |hashA|
                # pushing data from tableA to tableC based on @where_criteria
                csv2.each do |hashB|
                    if (hashA[@where_column.to_sym] == @where_criteria && hashB[@where_column.to_sym] == @where_criteria)
                        # add to tableC
                        joined_table[jIndex] = hashA
                        jIndex+=1
                        break
                    end
                end
            end
        else
            # printing out smashed table
        end
=end


