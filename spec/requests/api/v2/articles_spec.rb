require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'V2 Articles', type: :request do
  let(:user) { create :user }
  let(:user_two) { create :user }
  let(:article) { create :article, user: user }
  let(:article_two) { create :article, user: user_two }

  let(:valid_attributes) { attributes_for :article, user: user }
  let(:invalid_attributes) { attributes_for :invalid_article, user: user }

  let(:valid_headers) { user.create_new_auth_token }

  describe 'GET /articles' do
    it 'renders a successful response' do
      get api_articles_url, headers: {}, as: :json
      expect(response).to have_http_status(:success)
    end

    it 'renders two articles from distinct users' do
      article
      article_two

      get api_articles_url, headers: {}, as: :json
      expect(json_response.size).to eq 2
    end

    it 'renders an empty list' do
      get api_articles_url, headers: {}, as: :json
      expect(json_response[:articles].size).to eq 0
    end

    it 'renders the pagination data on the response' do
      article

      get api_articles_url, params: { page: 2, size: 10 }, headers: {}
      expect(response).to have_http_status(:success)
      expect(json_response[:meta][:currentPage]).to eq(2)
      expect(json_response[:meta][:itemsPerPage]).to eq(10)
      expect(json_response[:meta][:totalItems]).to eq(1)
    end
  end

  describe 'GET /articles/:id' do
    it 'renders a successful response' do
      get api_article_url(article), headers: valid_headers, as: :json
      expect(response).to have_http_status(:success)
    end

    it_behaves_like "trying to access another user's resource" do
      let(:url) do
        get api_article_url(article_two), headers: valid_headers, as: :json
      end
    end

    it_behaves_like 'user not logged in' do
      let(:url) do
        get api_article_url(article), headers: {}, as: :json
      end
    end
  end

  describe 'POST /articles' do
    context 'with valid parameters' do
      it 'creates a new Article' do
        expect do
          post api_articles_url,
               params: { article: valid_attributes },
               headers: valid_headers,
               as: :json
        end.to change(Article, :count).by(1)
      end

      it 'renders a JSON response with the new article' do
        post api_articles_url,
             params: { article: valid_attributes },
             headers: valid_headers,
             as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Article' do
        expect do
          post api_articles_url,
               params: { article: invalid_attributes },
               headers: valid_headers,
               as: :json
        end.to change(Article, :count).by(0)
      end

      it 'renders a JSON response with errors for the new article' do
        post api_articles_url,
             params: { article: invalid_attributes },
             headers: valid_headers,
             as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    it_behaves_like 'user not logged in' do
      let(:url) do
        post api_articles_url,
             params: { article: valid_attributes },
             headers: {},
             as: :json
      end
    end
  end

  describe 'PUT /articles/:id' do
    context 'with valid parameters' do
      let(:new_attributes) { attributes_for :article }

      it 'updates the requested article' do
        put api_article_url(article), params: {
          article: new_attributes
        }, headers: valid_headers, as: :json
        article.reload
        expect(article.title).to eq(new_attributes[:title])
      end

      it 'renders a JSON response with the article' do
        put api_article_url(article), params: {
          article: new_attributes
        }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'with invalid parameters' do
      it 'renders a JSON response with errors for the article' do
        put api_article_url(article), params: {
          article: invalid_attributes
        }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    it_behaves_like "trying to access another user's resource" do
      let(:url) do
        put api_article_url(article_two), headers: valid_headers, as: :json
      end
    end

    it_behaves_like 'user not logged in' do
      let(:url) do
        put api_article_url(article), params: {
          article: valid_attributes
        }, headers: {}, as: :json
      end
    end
  end

  describe 'DELETE /articles/:id' do
    it 'destroys the requested article' do
      article
      expect do
        delete api_article_url(article), headers: valid_headers, as: :json
      end.to change(Article, :count).by(-1)
    end

    it_behaves_like "trying to access another user's resource" do
      let(:url) do
        delete api_article_url(article_two), headers: valid_headers, as: :json
      end
    end

    it_behaves_like 'user not logged in' do
      let(:url) do
        delete api_article_url(article), headers: {}, as: :json
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
