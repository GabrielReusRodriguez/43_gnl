# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: greus-ro <greus-ro@student.42barcel>       +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/01/13 02:39:39 by greus-ro          #+#    #+#              #
#    Updated: 2024/11/01 19:53:45 by greus-ro         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

INC_DIR=./include
OBJ_DIR=./build
BIN_DIR=./bin
SRC_DIR=./src

NAME		= libgnl.a

CC			= cc
ifdef	CSANITIZE
	SANITIZE_FLAGS	= -g3 -fsanitize=address -fsanitize=leak
endif
CFLAGS		= -Wall -Werror -Wextra -MMD -MP
DFLAGS		= -D BUFFER_SIZE=30

SRC		= 	ft_get_next_line.c 				\
			ft_get_next_line_bonus.c 		\

SRCS	= $(patsubst %.c, ${SRC_DIR}/%.c, ${SRC})
OBJS	= $(patsubst %.c, ${OBJ_DIR}/%.o, ${SRC})
DEPS	= $(patsubst %.c, ${OBJ_DIR}/%.d, ${SRC})

all: folders ${BIN_DIR}/${NAME}
	
${BIN_DIR}/${NAME}: ${OBJS}
	ar -rcs ${BIN_DIR}/${NAME} ${OBJS}
	
${OBJ_DIR}/%.o:${SRC_DIR}/%.c Makefile
	${CC} ${CFLAGS} ${SANITIZE_FLAGS} ${DFLAGS} -I ${INC_DIR} -I ${LIBFT_DIR}/include -o $@ -c $<
#	${CC} ${CFLAGS} ${DFLAGS} -I ${INC_DIR} -I ${LIBFT_DIR}/include -o $@ -c $<

clean:
	rm -rf ${OBJ_DIR}
	

fclean: clean 
	rm -rf ${BIN_DIR}

re: fclean all

folders: 
	@mkdir -p ${BIN_DIR}
	@mkdir -p ${OBJ_DIR}
	
-include ${DEP_FILES}

.PHONY: all clean fclean re folders
