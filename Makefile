NAME = minitalk
SRCS = server.c client.c
CC = cc
CFLAGS = -Wall -Wextra -Werror -g
LIBFT_PATH = ./libft
LIBFT = $(LIBFT_PATH)/libft.a
PRINTF_PATH = ./ft_printf
PRINTF = $(PRINTF_PATH)/libftprintf.a

SRCS_SERVER = server.c
SRCS_CLIENT = client.c
OBJS_SERVER = $(SRCS_SERVER:.c=.o)
OBJS_CLIENT = $(SRCS_CLIENT:.c=.o)


SRCS_SERVER_BONUS = server_bonus.c
SRCS_CLIENT_BONUS = client_bonus.c
OBJS_SERVER_BONUS = $(SRCS_SERVER_BONUS:.c=.o)
OBJS_CLIENT_BONUS = $(SRCS_CLIENT_BONUS:.c=.o)


NAME_SERVER = server
NAME_CLIENT = client
NAME_SERVER_BONUS = server_bonus
NAME_CLIENT_BONUS = client_bonus

all: $(LIBFT) $(PRINTF) $(NAME_SERVER) $(NAME_CLIENT)

bonus: $(LIBFT) $(PRINTF) $(NAME_SERVER_BONUS) $(NAME_CLIENT_BONUS)


$(LIBFT):
	@echo "Checking LIBFT repository..."
	@if [ ! -d "$(LIBFT_PATH)" ]; then \
		echo "Cloning LIBFT repository..."; \
		git clone https://github.com/ilyasguney/libft.git $(LIBFT_PATH); \
	else \
		echo "LIBFT repository already exists, skipping clone."; \
	fi
	@echo "Building LIBFT library..."
	@make -C $(LIBFT_PATH)


$(PRINTF):
	@echo "Checking printf repository..."
	@if [ ! -d "$(PRINTF_PATH)" ]; then \
		echo "Cloning printf repository..."; \
		git clone https://github.com/ilyasguney/printf.git $(PRINTF_PATH); \
	else \
		echo "printf repository already exists, skipping clone."; \
	fi
	@echo "Building printf library..."
	@make -C $(PRINTF_PATH)

$(NAME_SERVER): $(OBJS_SERVER) $(LIBFT) $(PRINTF)
	$(CC) $(CFLAGS) $(OBJS_SERVER) $(LIBFT) $(PRINTF) -o $(NAME_SERVER)


$(NAME_CLIENT): $(OBJS_CLIENT) $(LIBFT) $(PRINTF)
	$(CC) $(CFLAGS) $(OBJS_CLIENT) $(LIBFT) $(PRINTF) -o $(NAME_CLIENT)


$(NAME_SERVER_BONUS): $(OBJS_SERVER_BONUS) $(LIBFT) $(PRINTF)
	$(CC) $(CFLAGS) $(OBJS_SERVER_BONUS) $(LIBFT) $(PRINTF) -o $(NAME_SERVER_BONUS)


$(NAME_CLIENT_BONUS): $(OBJS_CLIENT_BONUS) $(LIBFT) $(PRINTF)
	$(CC) $(CFLAGS) $(OBJS_CLIENT_BONUS) $(LIBFT) $(PRINTF) -o $(NAME_CLIENT_BONUS)


%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	@make clean -C $(PRINTF_PATH)
	@make clean -C $(LIBFT_PATH)
	@rm -rf $(OBJS_SERVER) $(OBJS_CLIENT) $(OBJS_SERVER_BONUS) $(OBJS_CLIENT_BONUS)

fclean: clean
	@make fclean -C $(PRINTF_PATH)
	@make fclean -C $(LIBFT_PATH)
	@rm -rf $(NAME_SERVER) $(NAME_CLIENT) $(NAME_SERVER_BONUS) $(NAME_CLIENT_BONUS)
	@rm -rf ft_printf
	@rm -rf libft

re: fclean all

.PHONY: all clean re fclean bonus