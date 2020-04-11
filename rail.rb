class RailFenceCipher
  def self.encode(msg, rails)
    return msg if rails == 1 || msg.length <= rails
    str = condense(msg)
    array = zigzag(str, rails)
    scoop_lines(array)
  end

  # Builds 'rail fence' using str argument
  # since it's the length we need.
  # Loops through each sub array, substituting
  # each non-'.' with an encoded message char.
  def self.decode(str, rails)
    return str if rails == 1 || str.length <= rails
    str_array = str.split('')
    array = zigzag(str, rails)
    array.each do |arr|
      arr.each_with_index do |char, i|
        arr[i] = str_array.shift unless char == '.'
      end
    end
    squishify(array)
  end

  private

  # removes non-letters and upcases
  def self.condense(str)
    str.gsub(/[^a-z]/i, '').upcase
  end

  # makes a 'rail fence' from the message
  def self.zigzag(str, rails)
    array = []
  
    0.upto(rails - 1) do
      array.push([])
    end

    j = 0
    i = 0
  
    while i < str.length do
      # counting up
      while j < rails - 1 && i < str.length do
        array.each_with_index do |arr, index|
          arr.push(str[i]) if     index == j
          arr.push('.')    unless index == j     
        end
        j += 1
        i += 1
      end
      # counting down
      while j > 0 && i < str.length do
        array.each_with_index do |arr, index|
          arr.push(str[i]) if     index == j
          arr.push('.')    unless index == j     
        end
        j -= 1
        i += 1
      end
    end

    array
  end

  # collect the message characters and
  # join to a string
  def self.scoop_lines(array)
    array.reduce("") do |concated, arr|
      concated + arr.select { |char| char != '.' }.join('')
    end
  end

  # takes zigzag array and reads out string
  def self.squishify(array)
    msg = ''
    (array[0].length).times do |i|
      array.each do |arr|
        msg << arr[i] unless arr[i] == '.'
      end
    end
    msg
  end
end

puts RailFenceCipher.encode("hi there", 1)
puts RailFenceCipher.encode("hi there", 20)
puts RailFenceCipher.encode("hi there", 2)
puts RailFenceCipher.encode("hi everybody", 3)
puts RailFenceCipher.encode("hi everybody", 4)
puts RailFenceCipher.encode("this is only a test", 5)

p RailFenceCipher.decode(RailFenceCipher.encode("this is only a test", 5), 5)
p RailFenceCipher.decode(RailFenceCipher.encode("felis catus is your taxonomic nomenclature", 5), 5)