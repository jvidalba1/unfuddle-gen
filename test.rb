
a = [1,2,3,4,5,6,7,8,9]
puts "enter a number from array #{a}: "
@m = gets.chomp
@n = @m.to_i
found = false
# while @v.nil?
a.each do |number|
	puts number
	if number.eql? @n
		@v = number 
		found = true
	end
	if not found 
		puts "please choose one from array #{a}"
		puts "enter a number from array #{a}: "
		@m = gets.chomp
		@n = @m.to_i
	end
end
# end