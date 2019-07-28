module BooksHelper
  def get_execution_nums(book_models)
    display_num = 10
    limit = book_models.count > display_num ? display_num : book_models.count

    execution_nums = []
    randam_nums = (0..book_models.count-1).to_a.sample(book_models.count)

    randam_nums.each do |num|
      unless book_models[num]['profile_image_id'].nil?
        execution_nums.push(num)
      end
      if execution_nums.count == limit
        break
      end
    end

    execution_nums

  end
end
