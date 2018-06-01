shared_examples_for "Ratingable" do
  describe 'PATCH #rating_up' do
    context 'Not author voted for answer' do
      it 'the number rating of answers' do
        patch :rating_up, params: { id: not_author_object.id, format: :json }
        not_author_object.reload
        expect(not_author_object.diff_like).to eq 1
      end
    end

    context 'author voted for answer' do
      it 'the number rating of answers' do
        patch :rating_up, params: { id: author_object.id, format: :json }
        author_object.reload
        expect(author_object.diff_like).to eq 0
      end
    end
  end

  describe 'PATCH #rating_down' do
    context 'Not author voted for answer' do
      it 'the number rating of answers' do
        patch :rating_down, params: { id: not_author_object.id, format: :json }
        not_author_object.reload
        expect(not_author_object.diff_like).to eq -1
      end
    end

    context 'author voted for answer' do
      it 'the number rating of answers' do
        patch :rating_down, params: { id: author_object.id, format: :json }
        author_object.reload
        expect(author_object.diff_like).to eq 0
      end
    end
  end

  describe 'PATCH #rating_reset' do
    context 'Not author voted for answer' do
      it 'the number rating of answers' do
        patch :rating_down, params: { id: not_author_object.id, format: :json }
        not_author_object.reload
        patch :rating_reset, params: { id: not_author_object.id, format: :json }
        not_author_object.reload
        expect(not_author_object.diff_like).to eq 0
      end
    end
  end
end